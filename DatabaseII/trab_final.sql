-- DROP TABLE IF EXISTS Pessoa CASCADE;
CREATE TABLE Pessoa(
    cod_pessoa INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL CONSTRAINT cod_pessoa PRIMARY KEY,
    nome_pessoa VARCHAR (200) NOT NULL
);

-- DROP TABLE IF EXISTS FUNCIONARIO CASCADE;
CREATE TABLE Funcionario (
    telefone VARCHAR(13) NOT NULL,
    email_contato VARCHAR(100) NOT NULL,
	CONSTRAINT cod_funcionario PRIMARY KEY (cod_pessoa)
) INHERITS(Pessoa);

-- DROP TABLE IF EXISTS Usuario CASCADE;
CREATE TABLE Usuario (
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(13) NOT NULL,
    email_contato VARCHAR(100),
	CONSTRAINT cod_usuario PRIMARY KEY (cod_pessoa)
) INHERITS(Pessoa);

-- DROP TABLE IF EXISTS Autor CASCADE;
CREATE TABLE Autor (
	CONSTRAINT cod_autor PRIMARY KEY (cod_pessoa)
) INHERITS(Pessoa);

-- DROP TABLE IF EXISTS Editora CASCADE;
CREATE TABLE Editora (
    cod_editora INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL CONSTRAINT cod_editora PRIMARY KEY,
    nome_editora VARCHAR(50) NOT NULL,
    email_editora VARCHAR(100)
);

-- DROP TABLE IF EXISTS Livro CASCADE;
CREATE TABLE Livro (
    cod_livro INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	isbn VARCHAR(13),
    disponivel BOOLEAN NOT NULL,
    nome_livro VARCHAR(200) NOT NULL,
    genero VARCHAR(20),
    nome_pessoa VARCHAR(200) NOT NULL,
    cod_pessoa INTEGER NOT NULL,
    cod_editora INTEGER NOT NULL,
    CONSTRAINT FK_cod_autor FOREIGN KEY (cod_pessoa) REFERENCES Autor (cod_pessoa),
    CONSTRAINT FK_cod_editora FOREIGN KEY (cod_editora) REFERENCES Editora (cod_editora)    
);

-- DROP TABLE IF EXISTS Emprestimo CASCADE;
CREATE TABLE Emprestimo (
    cod_emp INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    data_emp DATE NOT NULL,
    data_venc DATE NOT NULL,
    data_devolucao DATE,
    status BOOLEAN NOT NULL, -- 1 ATIVO 0 INATIVO
    cpf VARCHAR(14) NOT NULL,
    cod_livro INTEGER NOT NULL,
    cod_funcionario INTEGER NOT NULL,
    CONSTRAINT FK_cpf_usuario FOREIGN KEY (cpf) REFERENCES Usuario (cpf),
    CONSTRAINT FK_cod_livro FOREIGN KEY (cod_livro) REFERENCES Livro (cod_livro),
    CONSTRAINT FK_cod_funcionario FOREIGN KEY (cod_funcionario) REFERENCES Funcionario (cod_pessoa)
);

-- DROP TABLE IF EXISTS Multa CASCADE;
CREATE TABLE Multa (
    cod_multa INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    cod_emp INTEGER NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    valor NUMERIC NOT NULL,
	pago BOOLEAN NOT NULL,
    CONSTRAINT FK_codigo_emprestimo FOREIGN KEY (cod_emp) REFERENCES Emprestimo (cod_emp),
    CONSTRAINT FK_cpf_usuario FOREIGN KEY (cpf) REFERENCES Usuario (cpf)
);

-- DROP TABLE IF EXISTS Escreve CASCADE;
CREATE TABLE Escreve (
    cod_pessoa INTEGER,
    cod_livro INTEGER,
    CONSTRAINT PK_escreve PRIMARY KEY (cod_pessoa, cod_livro),
    CONSTRAINT FK_livro FOREIGN KEY (cod_livro) REFERENCES livro (cod_livro),
    CONSTRAINT FK_autor FOREIGN KEY (cod_pessoa) REFERENCES Autor (cod_pessoa)
);

-- DROP TABLE IF EXISTS audit_emprestimo CASCADE;
CREATE TABLE audit_emprestimo (
    operacao CHAR,
    data TIMESTAMP,
    usuario VARCHAR,
    cod_emp INTEGER ,
    data_emp DATE,
    data_venc DATE,
    data_devolucao DATE,
    status BOOLEAN,
    cpf VARCHAR(14),
    cod_livro INTEGER,
    cod_funcionario INTEGER
);

------------------------------------------------------
---------------------- TRIGGERS ----------------------
------------------------------------------------------

----- Trigger para Validar Pessoa
CREATE OR REPLACE FUNCTION validar_funcionario()
RETURNS TRIGGER AS $$
BEGIN
    NEW.nome_pessoa = LOWER(NEW.nome_pessoa);

    IF NEW.telefone !~ '^\d{2}\d{4}-\d{4}$' OR NEW.telefone IS NULL THEN
        RAISE EXCEPTION 'O telefone do funcionário deve estar no formato (DD)XXXX-XXXX.';
    END IF;
    
    IF NEW.email_contato !~ '^.+@biblioteca\.com\.br$' OR NEW.email_contato IS NULL THEN
        RAISE EXCEPTION 'O email do funcionário deve estar no formato xxxx@biblioteca.com.br.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_validar_funcionario
BEFORE INSERT OR UPDATE ON Funcionario
FOR EACH ROW
EXECUTE FUNCTION validar_funcionario();


----- Trigger para Validar Usuario
CREATE OR REPLACE FUNCTION validar_usuario()
RETURNS TRIGGER AS $$
BEGIN
    NEW.nome_pessoa = LOWER(NEW.nome_pessoa);

    IF NEW.cpf !~ '^\d{3}\.\d{3}\.\d{3}-\d{2}$' THEN
        RAISE EXCEPTION 'O CPF deve estar no formato xxx.xxx.xxx-xx.';
    END IF;
    
    IF NEW.telefone !~ '^\d{2}\d{4}-\d{4}$' OR NEW.telefone IS NULL THEN
        RAISE EXCEPTION 'O telefone do usuário deve estar no formato (DD)XXXX-XXXX.';
    END IF;
    
    IF NEW.email_contato IS NOT NULL THEN
        IF EXISTS (SELECT 1 FROM Usuario WHERE email_contato = NEW.email_contato AND cod_pessoa <> NEW.cod_pessoa) THEN
            RAISE EXCEPTION 'Email de usuário já está em uso';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER trigger_validar_usuario
BEFORE INSERT OR UPDATE ON Usuario
FOR EACH ROW
EXECUTE FUNCTION validar_usuario();

----- Trigger para Validar Emprestimo
CREATE OR REPLACE FUNCTION validar_emprestimo()
RETURNS TRIGGER AS $$
DECLARE
	qtde_disponiveis INTEGER;
BEGIN
	SELECT COUNT(*) INTO qtde_disponiveis 
	FROM Livro 
	WHERE isbn = NEW.isbn AND disponivel = TRUE; 
	--- validar se livro existe
	IF qtde_disponiveis <= 0 THEN
        RAISE EXCEPTION 'Livro indisponível.';
	END IF;
	IF (SELECT cpf FROM Multa WHERE cpf = NEW.cpf AND pago = FALSE) THEN
		RAISE EXCEPTION 'Não é possível realizar empréstimo, multas pendentes.';
	END IF;
	IF NEW.data_venc <> NEW.data_emp + INTERVAL '7 days' THEN
        RAISE EXCEPTION 'A data de vencimento deve ser 7 dias após a data de empréstimo.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_valida_emprestimo
BEFORE INSERT OR UPDATE ON Emprestimo
FOR EACH ROW
EXECUTE FUNCTION validar_emprestimo();

----- Trigger Inserção auditoria
CREATE OR REPLACE FUNCTION insert_audit_table()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO audit_emprestimo SELECT 'D', now(), user, OLD.*; 
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO audit_emprestimo SELECT 'U', now(), user, NEW.*; 
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO audit_emprestimo SELECT 'I', now(), user, NEW.*; 
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_insert_audit_table
AFTER INSERT OR UPDATE OR DELETE ON Emprestimo
FOR EACH ROW
EXECUTE FUNCTION insert_audit_table();

-----------------------------------------------------
---------------------- FUNÇÕES ----------------------
-----------------------------------------------------

---- Função para atualizar multa
CREATE OR REPLACE FUNCTION atualizar_multa()
RETURNS VOID AS $$
DECLARE
    data_venc DATE;
    data_devolucao DATE;
    cod_emp INTEGER;
    diff_days INTEGER;
    valor_multa NUMERIC;
BEGIN
    FOR data_venc, data_devolucao, cod_emp IN
        SELECT data_venc, data_devolucao, cod_emp
        FROM Emprestimo
        WHERE status = 0
    LOOP
        IF data_devolucao IS NULL THEN
            diff_days := EXTRACT(DAY FROM AGE(CURRENT_DATE, data_venc));
        ELSE
            diff_days := EXTRACT(DAY FROM AGE(data_devolucao, data_venc));
        END IF;

        valor_multa := diff_days * 0.50; -- Valor da multa: R$0,50 por dia de atraso (multiplicado por 100 para armazenar como inteiro)

        UPDATE Multa
        SET valor = valor_multa
        WHERE cod_emp = cod_emp;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;




---- Função para Renovar Emprestimo
CREATE OR REPLACE FUNCTION renovar_emprestimo()
RETURNS VOID AS $$
DECLARE
    data_venc DATE;
    data_devolucao DATE;
    cod_emp INTEGER;
BEGIN
    SELECT data_venc, data_devolucao, cod_emp INTO data_venc, data_devolucao, cod_emp
    FROM Emprestimo
    WHERE status = 1;

    IF CURRENT_DATE <= data_venc THEN
        data_venc := data_venc + interval '7 days';
  	END IF;

    UPDATE Emprestimo
    SET data_venc = data_vencimento
    WHERE cod_emp = cod_emp;

    RETURN;
END;
$$ LANGUAGE plpgsql;

---- Função para Inserir Livro
CREATE OR REPLACE FUNCTION INSERIRLIVRO()

-- POSTERGAR RESTRICOES NA PROCEDURE
 
-----------------------------------------------------
--------------------- INSERÇÕES ---------------------
-----------------------------------------------------
--- Procedure para inserir livro/autor
DO
$do$
BEGIN
    FOR i IN 1..1000 LOOP 
        INSERT INTO Funcionario (nome_servidor, tel_servidor, email_servidor) 
        VALUES ('Funcionario ' || i, floor(random() * (999999999-100000000+1) + 100000000)::VARCHAR, 'Funcionario' || i || '@gmail.com');
        
        INSERT INTO Autor (nome_autor) 
        VALUES ('Autor ' || i);
        
        INSERT INTO Editora (nome_editora, email_editora) 
        VALUES ('Editora ' || i, 'Editora' || i || '@gmail.com');

    END LOOP;
END
$do$

DO
$do$
BEGIN
    FOR i IN 1..10000 LOOP       
        
        INSERT INTO Usuario (cpf, nome_usuario, tel_usuario, email_usuario) 
        VALUES (lpad(i::VARCHAR, 11, '0'), 'Usuario ' || i, floor(random() * (999999999-100000000+1) + 100000000)::VARCHAR, 'Usuario' || i || '@gmail.com');

        INSERT INTO Livro (isbn, nome_livro, genero, nome_autor, cod_autor_livro, cod_editora_livro) 
        VALUES (lpad(i::VARCHAR, 13, '0'), 'Livro ' || i, 'Genero ' || (i % 200), 'Autor ' || (i % 10 + 1), (i % 10 + 1), (i % 10 + 1));
        
        INSERT INTO Emprestimo (data_emp, data_venc, status, atraso, cpf_usuario, cod_livro_emprestimo) 
        VALUES (current_date - (i % 30), current_date + (i % 30), i % 2, i % 2 = 0, lpad(i::VARCHAR, 11, '0'), lpad(i::VARCHAR, 13, '0'));
    END LOOP;
END
$do$

SELECT * from Usuario;

-----------------------------------------------------
---------------------- INDEXES ----------------------
-----------------------------------------------------

EXPLAIN SELECT * FROM Usuario WHERE cpf = '00000003252';
--Index Scan using usuario_pkey on usuario  (cost=0.29..8.30 rows=1 width=55)
--  Index Cond: ((cpf)::text = '00000003253'::text)

CREATE INDEX idx_usuario_cpf
ON Usuario (cpf);

EXPLAIN SELECT * FROM Usuario WHERE cpf = '00000003253';
--Index Scan using idx_usuario_cpf on usuario  (cost=0.29..8.30 rows=1 width=55)
--  Index Cond: ((cpf)::text = '00000003252'::text)

SELECT * from Emprestimo;

EXPLAIN SELECT * FROM Emprestimo WHERE cpf_usuario = '00000002683'
--Seq Scan on emprestimo  (cost=0.00..219.00 rows=1 width=43)
--  Filter: ((cpf_usuario)::text = '00000002683'::text)

CREATE INDEX idx_emprestimo_cpf_usuario
ON Emprestimo (cpf_usuario);

EXPLAIN SELECT * FROM Emprestimo WHERE cpf_usuario = '00000002683'
--Index Scan using idx_emprestimo_cpf_usuario on emprestimo  (cost=0.29..8.30 rows=1 width=43)
--  Index Cond: ((cpf_usuario)::text = '00000002683'::text)

EXPLAIN SELECT * FROM Emprestimo WHERE cod_livro_emprestimo = '0000000002258'
--Seq Scan on emprestimo  (cost=0.00..219.00 rows=1 width=43)
--  Filter: ((cod_livro_emprestimo)::text = '0000000002258'::text)

CREATE INDEX idx_emprestimo_cod_livro_emprestimo
ON Emprestimo (cod_livro_emprestimo);

EXPLAIN SELECT * FROM Emprestimo WHERE cod_livro_emprestimo = '0000000002258'
--Index Scan using idx_emprestimo_cod_livro_emprestimo on emprestimo  (cost=0.29..8.30 rows=1 width=43)
--  Index Cond: ((cod_livro_emprestimo)::text = '0000000002258'::text)

SELECT * FROM Livro;
EXPLAIN SELECT * FROM Livro WHERE genero = 'Genero 36';
--Seq Scan on livro  (cost=0.00..229.00 rows=50 width=52)
--  Filter: ((genero)::text = 'Genero 36'::text)

CREATE INDEX idx_livro_genero
ON Livro (genero);

EXPLAIN SELECT * FROM Livro WHERE genero = 'Genero 36';
--Bitmap Heap Scan on livro  (cost=4.67..92.07 rows=50 width=52)
--  Recheck Cond: ((genero)::text = 'Genero 36'::text)
--  ->  Bitmap Index Scan on idx_livro_genero  (cost=0.00..4.66 rows=50 width=0)
--        Index Cond: ((genero)::text = 'Genero 36'::text)


-----------------------------------------------------
----------------------- VIEWS -----------------------
-----------------------------------------------------

-- CREATE OR REPLACE VIEW EmprestimoGenero AS
-- SELECT count(e.*), l.genero FROM Emprestimo e NATURAL JOIN Livro l GROUP BY l.genero ORDER BY 1;

-- CREATE OR REPLACE VIEW LivrosMaisEmprestados AS
-- SELECT count(e.*) FROM Emprestimo e NATURAL JOIN  Livro l GROUP BY l.isbn ORDER BY 1;

-- CREATE OR REPLACE VIEW MaiorDevedor AS
-- SELECT U.nome_pessoa AS MaioresMultas, e.multa 
-- FROM Emprestimo e NATURAL JOIN Usuario u
-- WHERE e.status = 1;



CREATE OR REPLACE VIEW genero_mais_emprestado AS
SELECT genero, COUNT(*) AS quantidade
FROM Livro
JOIN Emprestimo ON Livro.cod_livro = Emprestimo.cod_livro
GROUP BY genero
ORDER BY quantidade DESC
LIMIT 1;

CREATE OR REPLACE VIEW livro_mais_emprestado AS
SELECT nome_livro, COUNT(*) AS quantidade
FROM Livro
JOIN Emprestimo ON Livro.cod_livro = Emprestimo.cod_livro
GROUP BY nome_livro
ORDER BY quantidade DESC
LIMIT 1;

CREATE OR REPLACE VIEW valor_multas_por_pessoa AS
SELECT Pessoa.nome_pessoa, SUM(Multa.valor) AS valor_multas
FROM Pessoa
JOIN Multa ON Pessoa.cod_pessoa = Multa.cod_pessoa
GROUP BY Pessoa.nome_pessoa
ORDER BY valor_multas DESC;



--- VIEW LIVROS EM ATRASO 
CREATE OR REPLACE VIEW livros_em_atraso AS
SELECT Livro.nome_livro
FROM Livro
JOIN Emprestimo ON Livro.cod_livro = Emprestimo.cod_livro
WHERE Emprestimo.data_devolucao IS NULL OR Emprestimo.data_devolucao > CURRENT_DATE;



-- EXTRACT(DAY FROM AGE(CURRENT_DATE, data_venc))

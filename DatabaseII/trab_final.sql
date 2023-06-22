-- DROP TABLE IF EXISTS Pessoa CASCADE;
CREATE TABLE Pessoa(
    cod_pessoa INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL CONSTRAINT cod_pessoa PRIMARY KEY,
    nome_pessoa VARCHAR (200) NOT NULL 
);

-- DROP TABLE IF EXISTS FUNCIONARIO CASCADE;
CREATE TABLE Funcionario (
    tel_servidor VARCHAR(9),
    email_servidor VARCHAR(100) NOT NULL,
	CONSTRAINT cod_funcionario PRIMARY KEY (cod_pessoa)
) INHERITS(Pessoa);

-- DROP TABLE IF EXISTS Usuario CASCADE;
CREATE TABLE Usuario (
    cpf VARCHAR(11) UNIQUE NOT NULL,
    tel_usuario VARCHAR(9) NOT NULL,
    email_usuario VARCHAR(100),
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
    status BOOLEAN NOT NULL, -- 1 ATIVO 0 INATIVO
    multa NUMERIC,
    cpf VARCHAR(11) NOT NULL,
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
    cpf INTEGER NOT NULL,
    valor NUMERIC NOT NULL,
	pago BOOLEAN NOT NULL,
    CONSTRAINT FK_codigo_emprestimo FOREIGN KEY (cod_emp) REFERENCES Emprestimo (cod_emp)
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


--- Procedure para inserir livro/autor

------------------------------------------------------
---------------------- TRIGGERS ----------------------
------------------------------------------------------

----- Trigger para Validar Pessoa
CREATE OR REPLACE FUNCTION validar_pessoa()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.data_reg > DATE(NOW()) THEN
        RAISE EXCEPTION 'A data de registro não pode ser posterior à data atual.';
    END IF;

    NEW.nome = LOWER(NEW.nome);

    IF NEW.cpf !~ '^\d{3}\.\d{3}\.\d{3}-\d{2}$' THEN
        RAISE EXCEPTION 'O CPF deve estar no formato xxx.xxx.xxx-xx.';
    END IF;
    -- validar mascara de email
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_validar_funcionario
BEFORE INSERT OR UPDATE ON Funcionario
FOR EACH ROW
EXECUTE FUNCTION validar_pessoa();

CREATE OR REPLACE TRIGGER trigger_validar_usuario
BEFORE INSERT OR UPDATE ON Usuario
FOR EACH ROW
EXECUTE FUNCTION validar_pessoa();

----- Trigger para Validar Emprestimo
CREATE OR REPLACE FUNCTION validar_emprestimo()
RETURNS TRIGGER AS $$
DECLARE
	qtde_disponiveis INTEGER;
BEGIN
	SELECT COUNT(*) INTO qtde_disponiveis 
	FROM Livro 
	WHERE isbn = NEW.isbn AND disponivel = TRUE; 
	IF qtde_disponiveis <= 0 THEN
        RAISE EXCEPTION 'Livro indisponível.';
	END IF;
	IF (SELECT (*) FROM Multa WHERE codigo_usuario = NEW.cpf AND pago = FALSE) THEN
		RAISE EXCEPTION 'Não é possível realizar empréstimo, multas pendentes.'
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_valida_emprestimo
BEFORE INSERT OR UPDATE ON Emprestimo
FOR EACH ROW
EXECUTE FUNCTION validar_emprestimo();


----- Trigger para X coisa
CREATE OR REPLACE FUNCTION Nome_Funcao()
RETURNS TRIGGER AS $$
BEGIN
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_nome_funcao
BEFORE INSERT OR UPDATE ON TABELA
FOR EACH ROW
EXECUTE FUNCTION Nome_Funcao();

-----------------------------------------------------
---------------------- FUNÇÕES ----------------------
-----------------------------------------------------

---- Função para X coisa
CREATE OR REPLACE FUNCTION AtualizaAtraso()

---- Função para X coisa
CREATE OR REPLACE FUNCTION AtualizaAtraso()

---- Função para X coisa
CREATE OR REPLACE FUNCTION AtualizaAtraso()
 
-----------------------------------------------------
--------------------- INSERÇÕES ---------------------
-----------------------------------------------------

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

CREATE OR REPLACE VIEW EmprestimoGenero AS
SELECT count(e.*), l.genero FROM Emprestimo e NATURAL JOIN Livro l GROUP BY l.genero ORDER BY 1;

CREATE OR REPLACE VIEW LivrosMaisEmprestados AS
SELECT count(e.*) FROM Emprestimo e NATURAL JOIN  Livro l GROUP BY l.isbn ORDER BY 1;

CREATE OR REPLACE VIEW MaiorDevedor AS
SELECT U.nome_pessoa AS MaioresMultas, e.multa 
FROM Emprestimo e NATURAL JOIN Usuario u
WHERE e.status = 1;

-- EXTRACT(DAY FROM AGE(CURRENT_DATE, data_venc))

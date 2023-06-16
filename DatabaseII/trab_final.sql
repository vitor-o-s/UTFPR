-- DROP TABLE IF EXISTS FUNCIONARIO;
CREATE TABLE Funcionario (
    cod_servidor SERIAL PRIMARY KEY NOT NULL,
    nome_servidor VARCHAR(200) NOT NULL,
    tel_servidor VARCHAR(9),
    email_servidor VARCHAR(100)
);

-- DROP TABLE IF EXISTS Usuario;
CREATE TABLE Usuario (
    cpf VARCHAR(11) PRIMARY KEY NOT NULL,
    nome_usuario VARCHAR(200) NOT NULL,
    tel_usuario VARCHAR(9) NOT NULL,
    email_usuario VARCHAR(100)
);

-- DROP TABLE IF EXISTS Autor;
CREATE TABLE Autor (
    cod_autor SERIAL PRIMARY KEY NOT NULL,
    nome_autor VARCHAR(200) NOT NULL
);

-- DROP TABLE IF EXISTS Editora;
CREATE TABLE Editora (
    cod_editora SERIAL PRIMARY KEY NOT NULL,
    nome_editora VARCHAR(50) NOT NULL,
    email_editora VARCHAR(100)
);

-- DROP TABLE IF EXISTS Livro;
CREATE TABLE Livro (
    isbn VARCHAR(13),
    cod_livro SERIAL PRIMARY KEY NOT NULL,
    disponivel BOOLEAN NOT NULL,
    nome_livro VARCHAR(200) NOT NULL,
    genero VARCHAR(20),
    nome_autor VARCHAR(200) NOT NULL,
    cod_autor_livro SERIAL NOT NULL,
    cod_editora_livro SERIAL NOT NULL
);

-- DROP TABLE IF EXISTS Emprestimo;
CREATE TABLE Emprestimo (
    cod_emp SERIAL PRIMARY KEY NOT NULL,
    data_emp DATE NOT NULL,
    data_venc DATE NOT NULL,
    status INTEGER NOT NULL, -- 1 ATIVO 0 INATIVO
    multa NUMERIC,
    cpf_usuario VARCHAR(11) NOT NULL,
    cod_livro_emprestimo SERIAL NOT NULL
);

-- DROP TABLE IF EXISTS Escreve;
CREATE TABLE Escreve (
    cod_autor SERIAL,
    cod_livro SERIAL,
    CONSTRAINT PK_escreve PRIMARY KEY (cod_autor, cod_livro),
    CONSTRAINT FK_livro FOREIGN KEY (cod_livro) REFERENCES livro (cod_livro),
    CONSTRAINT FK_autor FOREIGN KEY (cod_autor) REFERENCES Autor (cod_autor)
);

ALTER TABLE Livro
ADD CONSTRAINT cod_autor
FOREIGN KEY (cod_autor_livro)
REFERENCES Autor (cod_autor);

ALTER TABLE Livro
ADD CONSTRAINT cod_editora
FOREIGN KEY (cod_editora_livro)
REFERENCES Editora (cod_editora);

ALTER TABLE Emprestimo
ADD CONSTRAINT cpf_usuario
FOREIGN KEY (cpf_usuario)
REFERENCES Usuario (cpf);

ALTER TABLE Emprestimo
ADD CONSTRAINT cod_livro_emprestimo
FOREIGN KEY (cod_livro_emprestimo)
REFERENCES Livro (cod_livro);


--- Procedure para inserir livro/autor

------------------------------------------------------
---------------------- TRIGGERS ----------------------
------------------------------------------------------

----- Trigger para X coisa
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
SELECT count(*), genero FROM Emprestimo GROUP BY genero ORDER BY 1;

CREATE OR REPLACE VIEW LivrosMaisEmprestados AS
SELECT count(e.cod_livro_emprestimo), l.nome_livro FROM Emprestimo e JOIN  Livro l ON e.cod_livro_emprestimo = l.isbn GROUP BY cod_livro_emprestimo ORDER BY 1;

CREATE OR REPLACE VIEW MaiorDevedor AS
SELECT cpf_usuario, EXTRACT(DAY FROM AGE(CURRENT_DATE, data_venc)) AS valorMulta
FROM Emprestimo
WHERE atraso = TRUE;

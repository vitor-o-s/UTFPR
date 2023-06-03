-- DROP TABLE Departamento CASCADE;
-- DROP TABLE Funcionario CASCADE;

CREATE TABLE Departamento (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    numero_funcionarios INTEGER NOT NULL,
    max_mesas INTEGER NOT NULL,
    lotacao VARCHAR(20)
);

CREATE TABLE Funcionario (
    id SERIAL PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_reg DATE NOT NULL,
    id_dep INTEGER REFERENCES Departamento (id)
);

-- 1 Incrementa o num de funcionários no dept
CREATE OR REPLACE FUNCTION incrementar_funcionarios()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Departamento SET numero_funcionarios = numero_funcionarios + 1 WHERE id = NEW.id_dep;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_incrementar_funcionarios
AFTER INSERT ON Funcionario
FOR EACH ROW
EXECUTE FUNCTION incrementar_funcionarios();

-- 2 Decrementa o num de funcionários no dept
CREATE OR REPLACE FUNCTION decrementar_funcionarios()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Departamento SET numero_funcionarios = numero_funcionarios - 1 WHERE id = OLD.id_dep;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_decrementar_funcionarios
BEFORE DELETE ON Funcionario
FOR EACH ROW
EXECUTE FUNCTION decrementar_funcionarios();

-- 3 Atualiza num de funcionários no dept
CREATE OR REPLACE FUNCTION atualizar_funcionarios()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE Departamento SET numero_funcionarios = numero_funcionarios - 1 WHERE id = OLD.id_dep;
    UPDATE Departamento SET numero_funcionarios = numero_funcionarios + 1 WHERE id = NEW.id_dep;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_atualizar_funcionarios
AFTER UPDATE ON Funcionario
FOR EACH ROW
EXECUTE FUNCTION atualizar_funcionarios();

-- 4 Valida registro do funcionário
CREATE OR REPLACE FUNCTION validar_funcionario()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.data_reg > DATE(NOW()) THEN
        RAISE EXCEPTION 'A data de registro não pode ser posterior à data atual.';
    END IF;

    NEW.nome = LOWER(NEW.nome);

    IF NEW.cpf !~ '^\d{3}\.\d{3}\.\d{3}-\d{2}$' THEN
        RAISE EXCEPTION 'O CPF deve estar no formato xxx.xxx.xxx-xx.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_validar_funcionario
BEFORE INSERT OR UPDATE ON Funcionario
FOR EACH ROW
EXECUTE FUNCTION validar_funcionario();

-- 5 Informa lotação do departamento
CREATE OR REPLACE FUNCTION atualizar_lotacao()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.numero_funcionarios < 0.3 * NEW.max_mesas THEN
        NEW.lotacao = 'Mínimo';
    ELSIF NEW.numero_funcionarios >= 0.3 * NEW.max_mesas AND NEW.numero_funcionarios < 0.5 * NEW.max_mesas THEN
        NEW.lotacao = 'Médio';
    ELSIF NEW.numero_funcionarios >= 0.5 * NEW.max_mesas AND NEW.numero_funcionarios < 0.8 * NEW.max_mesas THEN
        NEW.lotacao = 'Parcialmente Cheio';
    ELSIF NEW.numero_funcionarios >= 0.8 * NEW.max_mesas AND NEW.numero_funcionarios < 1.0 * NEW.max_mesas THEN
        NEW.lotacao = 'Cheio';
	ELSE
		NEW.lotacao = 'Esgotado';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_atualizar_lotacao
BEFORE INSERT OR UPDATE ON Departamento
FOR EACH ROW
EXECUTE FUNCTION atualizar_lotacao();

-- Testes

INSERT INTO Departamento (nome, numero_funcionarios, max_mesas)
VALUES 
	('Departamento 1', 0, 10),
	('Departamento 2', 0, 15),
	('Departamento 3', 0, 25);

SELECT * FROM DEPARTAMENTO;

-- Inserção de funcionários no Departamento 1
INSERT INTO Funcionario (cpf, nome, data_reg, id_dep)
VALUES
    ('111.111.111-11', 'Funcionario 11', '2023-01-01', 1),
    ('222.222.222-21', 'Funcionario 21', '2023-01-02', 1),
    ('333.333.333-31', 'Funcionario 31', '2023-01-03', 1),
    ('444.444.444-41', 'Funcionario 41', '2023-01-04', 1),
    ('555.555.555-51', 'Funcionario 51', '2023-01-05', 1),
    ('666.666.666-61', 'Funcionario 61', '2023-01-06', 1),
    ('777.777.777-71', 'Funcionario 71', '2023-01-07', 1),
    ('888.888.888-81', 'Funcionario 81', '2023-01-08', 1),
    ('999.999.999-91', 'Funcionario 91', '2023-01-09', 1);

-- Inserção de funcionários no Departamento 2
INSERT INTO Funcionario (cpf, nome, data_reg, id_dep)
VALUES
    ('111.111.111-12', 'Funcionario 12', '2023-01-01', 2),
    ('222.222.222-22', 'Funcionario 22', '2023-01-02', 2),
    ('333.333.333-32', 'Funcionario 32', '2023-01-03', 2),
    ('444.444.444-42', 'Funcionario 42', '2023-01-04', 2),
    ('555.555.555-52', 'Funcionario 52', '2023-01-05', 2),
    ('666.666.666-62', 'Funcionario 62', '2023-01-06', 2),
    ('777.777.777-72', 'Funcionario 72', '2023-01-07', 2),
    ('888.888.888-82', 'Funcionario 82', '2023-01-08', 2),
    ('999.999.999-92', 'Funcionario 92', '2023-01-09', 2);
	
-- Inserção de funcionários no Departamento 3
INSERT INTO Funcionario (cpf, nome, data_reg, id_dep)
VALUES
    ('111.111.111-13', 'Funcionario 13', '2023-01-01', 3),
    ('222.222.222-23', 'Funcionario 23', '2023-01-02', 3),
    ('333.333.333-33', 'Funcionario 33', '2023-01-03', 3),
    ('444.444.444-43', 'Funcionario 43', '2023-01-04', 3),
    ('555.555.555-53', 'Funcionario 53', '2023-01-05', 3),
    ('666.666.666-63', 'Funcionario 63', '2023-01-06', 3),
    ('777.777.777-73', 'Funcionario 73', '2023-01-07', 3),
    ('888.888.888-83', 'Funcionario 83', '2023-01-08', 3),
    ('999.999.999-93', 'Funcionario 93', '2023-01-09', 3);

SELECT * FROM FUNCIONARIO;
--VALIDA Q1
SELECT * FROM DEPARTAMENTO;
-- Delete em funcionário
-- VALIDA Q2
DELETE FROM Funcionario WHERE id = 2;
SELECT * FROM FUNCIONARIO;
SELECT * FROM DEPARTAMENTO;

--VALIDA Q3 e Q5
UPDATE Funcionario SET id_dep = 1 WHERE id = 1;
SELECT * FROM FUNCIONARIO;
SELECT * FROM DEPARTAMENTO;

--VALIDA Q4
UPDATE Funcionario SET data_Reg = '2023-06-04' WHERE id = 1; -- Falha validação de data
UPDATE Funcionario SET cpf = '111111.111.04' WHERE id = 1; -- Falha validação de mascara
UPDATE Funcionario SET cpf = '111.A11.111.04' WHERE id = 1; -- Falha validação de mascara
INSERT INTO Funcionario (cpf, nome, data_reg, id_dep) VALUES ('111.111.11113', 'Funcionario 101', '2023-01-01', 1); -- Falha validação de mascara
SELECT * FROM FUNCIONARIO;


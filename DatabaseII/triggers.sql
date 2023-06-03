CREATE TABLE Funcionario (
    id SERIAL PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_reg DATE NOT NULL,
    id_dep INTEGER REFERENCES Departamento (id)
);

CREATE TABLE Departamento (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    numero_funcionarios INTEGER NOT NULL,
    max_mesas INTEGER NOT NULL,
    lotacao VARCHAR(20) NOT NULL
);

-- 1 Incrementa o num de funcionários no dept
CREATE OR REPLACE FUNCTION incrementar_funcionarios()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Departamento
    SET numero_funcionarios = numero_funcionarios + 1
    WHERE id = NEW.id_dep;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_incrementar_funcionarios
AFTER INSERT ON Funcionario
FOR EACH ROW
EXECUTE FUNCTION incrementar_funcionarios();

-- 2 Decrementa o num de funcionários no dept
CREATE OR REPLACE FUNCTION decrementar_funcionarios()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Departamento
    SET numero_funcionarios = numero_funcionarios - 1
    WHERE id = NEW.id_dep;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_decrementar_funcionarios
AFTER DELETE ON Funcionario
FOR EACH ROW
EXECUTE FUNCTION incrementar_funcionarios();

-- 3 Atualiza num de funcionários no dept
CREATE OR REPLACE FUNCTION atualizar_funcionarios()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Departamento
    SET numero_funcionarios = numero_funcionarios + 1
    WHERE id = NEW.id_dep;
	UPDATE Departamento
    SET numero_funcionarios = numero_funcionarios - 1
    WHERE id = OLD.id_dep;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_funcionarios
AFTER DELETE ON Funcionario
FOR EACH ROW
EXECUTE FUNCTION incrementar_funcionarios();

-- 4 Valida registro do funcionário
CREATE OR REPLACE FUNCTION validar_funcionario()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.data_reg > CURRENT_DATE THEN
        RAISE EXCEPTION 'A data de registro não pode ser posterior à data atual.';
    END IF;

    NEW.nome = LOWER(NEW.nome);

    IF NEW.cpf !~ '^\d{3}\.\d{3}\.\d{3}-\d{2}$' THEN
        RAISE EXCEPTION 'O CPF deve estar no formato xxx.xxx.xxx-xx.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_funcionario
BEFORE INSERT OR UPDATE ON Funcionario
FOR EACH ROW
EXECUTE FUNCTION validar_funcionario();

-- 5 Informa lotação do departamento
CREATE OR REPLACE FUNCTION atualizar_lotacao()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.numero_funcionarios < 0.3 * NEW.max_mesas THEN
        NEW.lotacao = 'Mínimo';
    ELSIF NEW.numero_funcionarios = 0.5 * NEW.max_mesas THEN
        NEW.lotacao = 'Médio';
    ELSIF NEW.numero_funcionarios > 0.5 * NEW.max_mesas AND NEW.numero_funcionarios < 0.8 * NEW.max_mesas THEN
        NEW.lotacao = 'Parcialmente Cheio';
    ELSIF NEW.numero_funcionarios > 0.8 * NEW.max_mesas AND NEW.numero_funcionarios < NEW.max_mesas THEN
        NEW.lotacao = 'Cheio';
	ELSE
		NEW.lotacao = 'Esgotado';
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_lotacao
BEFORE INSERT OR UPDATE ON Departamento
FOR EACH ROW
EXECUTE FUNCTION atualizar_lotacao();



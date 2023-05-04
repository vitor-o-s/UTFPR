CREATE TABLE Aluno(
RA DECIMAL(8) NOT NULL CONSTRAINT RegistroAcademico PRIMARY KEY, -- UNIQUE/ GARANTIDO por primary key -- AUTO INCREMENT ? SERIAL/IDENTITY
Nome VARCHAR(50) NOT NULL,
DataNasc DATE NOT NULL,
-- Idade DECIMAL(3), -- Não atende a 2FN
NomeMae VARCHAR(50) NOT NULL,
Cidade VARCHAR(30),
Estado CHAR(2),
Curso VARCHAR(50),
Periodo INTEGER
);

CREATE TABLE Discip(
Sigla CHAR(7) NOT NULL CONSTRAINT SiglaDisciplina PRIMARY KEY,
Nome VARCHAR(25) NOT NULL,
SiglaPreReq CHAR(7),
NNCred DECIMAL(2) NOT NULL,
Monitor DECIMAL(8),
Depto CHAR(8),
FOREIGN KEY (SiglaPreReq) REFERENCES Discip(Sigla),
FOREIGN KEY (Monitor) REFERENCES Aluno(RA)
);


CREATE TABLE Matricula(
RA DECIMAL(8) NOT NULL,
Sigla CHAR(7) NOT NULL,
Ano CHAR(4) NOT NULL,
Semestre CHAR(1) NOT NULL,
CodTurma DECIMAL(4) NOT NULL,
NotaP1 NUMERIC(3,1),
NotaP2 NUMERIC(3,1),
NotaTrab NUMERIC(3,1),
NotaFIM NUMERIC(3,1), -- Não necessario (2FN)
Frequencia DECIMAL(3),
PRIMARY KEY (RA, Sigla, Ano, Semestre, CodTurma),
FOREIGN KEY (RA) REFERENCES Aluno(RA),
FOREIGN KEY (Sigla) REFERENCES Discip(Sigla)
);

-------------- Funções

CREATE OR REPLACE FUNCTION GeraDept() RETURNS TEXT AS
$$
DECLARE
  varDepartamento varchar[] = '{"DAEELE", "DAINF", "DAMAT", "DALET", "DAMEC"}';
  results text := varDepartamento[FLOOR(random() * 5) + 1];
BEGIN
  RETURN results;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION NumCredito() RETURNS INTEGER AS
$$ 
BEGIN
  RETURN random() * 3 + 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GeraNome(tamanho INTEGER) RETURNS TEXT AS
$$
DECLARE
  chars text[] := '{A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
  result text := '';
  i integer := 0;
BEGIN
  IF tamanho < 0 THEN
    RAISE EXCEPTION 'Tamanho dado nao pode ser menor que zero';
  END IF;
  FOR i IN 1..tamanho LOOP
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  END LOOP;
  RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GeraNomeDisciplina() RETURNS TEXT AS
$$
DECLARE
  chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
  result text := '';
  i integer := 0;
BEGIN
  FOR i IN 1..25 LOOP
    result := result || chars[1 + random()*(array_length(chars, 1)-1)]
  END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GeraSigla() RETURNS TEXT AS
$$
DECLARE
  chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}';
  result text := '';
  i integer := 0;
BEGIN
  FOR i IN 1..7 LOOP
    result := result || chars[1 + random()*(array_length(chars, 1)-1)]
  END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION BuscaRA() RETURNS TEXT AS
$$
DECLARE
--- Como é chave estrangeira preciso buscar???
BEGIN
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GeraNasc() RETURNS DATE AS
$$
BEGIN
  RETURN date(timestamp '1980-01-01 00:00:00' +  random() * (timestamp '2005-05-04 00:00:00' - timestamp '1980-01-01 00:00:00'));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GeraEstado() RETURNS DATA AS
$$
DECLARE
  varEstado varchar[] = '{"AC", "AL", "AP", "AM", "BA", "CE", "ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC", "SP", "SE", "TO", "DF"}';
  results text := varEstado[FLOOR(random() * 26) + 1];
BEGIN
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GeraCurso() RETURNS TEXT AS
$$
DECLARE
  varCurso varchar[] = '{"ENGCOMP", "ENGELE", "ENGMEC", "ENGCIV", "LETRAS", "MATEMATICA"}';
  results text := varCurso[FLOOR(random() * 5) + 1];
BEGIN
  RETURN results;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GeraPeriodo() RETURNS INTEGER AS
$$
BEGIN
  RETURN random() * 9 + 1;
END;
$$ LANGUAGE plpgsql;

-------------- Popular Aluno

DO $$
BEGIN 
  FOR i IN 1..10000 LOOP 
    INSERT INTO ALUNO (Nome, DataNasc, NomeMae, Cidade, Estado, Curso, Periodo)
    VALUES(GeraNome(), GeraNasc(), GeraNome(), GeraNome(), GeraEstado(), GeraCurso(), GeraPeriodo()) ON conflict do nothing;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
ANALYZE Aluno;

-------------- Popular Disciplina

DO $$
BEGIN 
  FOR i IN 1..10000 LOOP 
    INSERT INTO Discip (Sigla, Nome, SiglaPreReq, NNCred, Monitor, Depto)
    VALUES(GeraSigla(), GeraNomeDisciplina(), GeraSigla(), NumCredito(), BuscaRA(), GeraDept()) ON conflict do nothing;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
ANALYZE Discip;


-------------- Popular Matricula

DO $$
BEGIN 
  FOR i IN 1..10000 LOOP 
    INSERT INTO Matricula (RA, Sigla, Ano, Semestre, CodTurma, NotaP1, NotaP2, NotaTrab, NotaFIM, Frequencia)
    VALUES(BuscaRA(), BuscaSigla(), GeraAno(), GeraSemestre(), GeraTurma(), GeraNota(), GeraNota(), GeraNota(), CalculaNota(), GeraFreq()) ON conflict do nothing;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
ANALYZE Matricula;

------------------- Q2 
-- Suponha que o seguinte índice foi criado para a relação Aluno.
CREATE UNIQUE INDEX IdxAlunoNNI ON Aluno (Nome, NomeMae, Idade);

 -- 1. Escreva uma consulta que utilize esse Índice.
 SELECT RA, Nome, NomeMae, Idade FROM Aluno WHERE Nome = '' AND NomeMae = '' AND Idade = 10;
 -- 2. Mostre um exemplo onde o Índice não é usado mesmo utilizando algum campo indexado na cláusula where, e explique por quê
 SELECT RA,  Nome, NomeMae, Idade FROM Aluno WHERE Nome = ''
 
 -- Neste caso, mesmo o campo Nome sendo parte do índice IdxAlunoNNI, o SGBD não irá utilizá-lo
 -- pois a consulta não especifica os valores das outras colunas (NomeMae e Idade) que também fazem parte do índice. 
 -- O SGBD pode optar por não utilizar o índice se considerar que a utilização do mesmo não traria ganhos significativos de desempenho
 -- na busca dos registros desejados.
------------------- Q3
-- Crie índices e mostre exemplos de consultas (resultados e explain) que usam os seguintes tipos de acessos:
-- a) Sequential Scan
-- b) Bitmap Index Scan
-- c) Index Scan
-- d) Index-Only Scan
-- e) Multi-Index Scan

------------------- Q4 
-- Faça consutas com junções entre as tabelas e mostre o desempenho criando-se índices para cada chave estrangeira.

------------------- Q5
-- Utilize um índice bitmap para o período e mostre-o em uso nas consultas

------------------- Q6
-- Compare na prática o custo de executar uma consulta com e sem um índice clusterizado na tabela aluno. 
-- Ou seja, faça uma consulta sobre algum dado indexado, clusterize a tabela naquele índice e refaça a consulta.
-- Mostre os comandos e os resultados do exlain analyze.

------------------- Q7
-- Acrescente um campo adicional na tabela de Aluno, chamado de informacoesExtras, do tipo JSON.
-- Insira dados diferentes telefônicos e de times de futebol que o aluno torce para cada aluno neste JSON.
-- Crie índices para o JSON e mostre consultas que o utiliza (explain analyze). 
-- Exemplo: retorne os alunos que torcem para o Internacional.





















Create or replace function texto(tamanho integer) returns text as
$$
declare
  chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
  result text := '';
  i integer := 0;
begin
  if tamanho < 0 then
    raise exception 'Tamanho dado nao pode ser menor que zero';
  end if;
  for i in 1..tamanho loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
  return result;
end;
$$ language plpgsql;


create or replace function data() returns date as
$$
   begin
   return date(timestamp '1980-01-01 00:00:00' +
       random() * (timestamp '2020-07-18 00:00:00' -
                   timestamp '1980-01-01 00:00:00'));
   end;
$$language plpgsql;

--set datestyle to "DMY,SQL"
--select data()

create function gera_idade() returns integer as 
$$
begin
	return TRUNC(RANDOM() * 130 + 2);
end
$$ language plpgsql

SELECT gera_idade();

do $$
begin
for i IN 1..5000 LOOP
insert into Aluno values (texto(30),RA,DAT,IDADE,nOMM,cID,ESTADO, CURSO, PERIODO);
end loop;
end $$;

CREATE TABLE Aluno(
Nome VARCHAR(50) NOT NULL,
RA DECIMAL(8) NOT NULL, -- SERIAL/IDENTITY
DataNasc DATE NOT NULL,
Idade DECIMAL(3), -- Integer
NomeMae VARCHAR(50) NOT NULL,
Cidade VARCHAR(30),
Estado CHAR(2), 
Curso VARCHAR(50),
periodo integer
);

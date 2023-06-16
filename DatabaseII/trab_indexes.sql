-- Trabalho feito por Andrea e Vitor
-- DROP TABLE IF EXISTS Aluno CASCADE;
CREATE TABLE IF NOT EXISTS Aluno(
RA INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL CONSTRAINT RegistroAcademico PRIMARY KEY,
Nome VARCHAR(50) NOT NULL,
DataNasc DATE NOT NULL,
-- Idade DECIMAL(3), -- Não atende a 2FN
NomeMae VARCHAR(50) NOT NULL,
Cidade VARCHAR(30),
Estado CHAR(2),
Curso VARCHAR(50),
Periodo INTEGER
);

-- DROP TABLE IF EXISTS Discip CASCADE;
CREATE TABLE IF NOT EXISTS Discip(
Sigla CHAR(7) NOT NULL CONSTRAINT SiglaDisciplina PRIMARY KEY,
Nome VARCHAR(25) NOT NULL,
SiglaPreReq CHAR(7),
NNCred DECIMAL(2) NOT NULL,
Monitor INTEGER,
Depto CHAR(8),
FOREIGN KEY (SiglaPreReq) REFERENCES Discip(Sigla),
FOREIGN KEY (Monitor) REFERENCES Aluno(RA)
);

-- DROP TABLE IF EXISTS Matricula CASCADE;
CREATE TABLE IF NOT EXISTS Matricula(
RA INTEGER NOT NULL,
Sigla CHAR(7) NOT NULL,
Ano CHAR(4) NOT NULL,
Semestre CHAR(1) NOT NULL,
CodTurma DECIMAL(4) NOT NULL,
NotaP1 NUMERIC(3,1),
NotaP2 NUMERIC(3,1),
NotaTrab NUMERIC(3,1),
-- NotaFIM NUMERIC(3,1), -- Não necessario (2FN)
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
SELECT GeraDept();

CREATE OR REPLACE FUNCTION NumCredito() RETURNS INTEGER AS
$$ 
BEGIN
  RETURN random() * 3 + 1;
END;
$$ LANGUAGE plpgsql;
SELECT NumCredito();

CREATE OR REPLACE FUNCTION GeraSemestre() RETURNS INTEGER AS
$$ 
BEGIN
  RETURN random() * 1 + 1;
END;
$$ LANGUAGE plpgsql;
SELECT GeraSemestre();

CREATE OR REPLACE FUNCTION GeraAno() RETURNS CHAR(4) AS
$$
DECLARE
  year INTEGER;
BEGIN
  year := FLOOR(random() * (2023 - 1990 + 1)) + 1990;
  RETURN year::CHAR(4);
END;
$$ LANGUAGE plpgsql;
SELECT GeraAno();

CREATE OR REPLACE FUNCTION GeraCodTurma() RETURNS DECIMAL AS
$$
DECLARE
  year INTEGER;
BEGIN
  year := FLOOR(random() * (2023 - 1990 + 1)) + 1990;
  RETURN year::DECIMAL(4);
END;
$$ LANGUAGE plpgsql;
SELECT GeraCodTurma();

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
    result := result || chars[1 + random()*(array_length(chars, 1)-1)];
  END LOOP;
  RETURN result;
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
    result := result || chars[1 + random()*(array_length(chars, 1)-1)];
  END LOOP;
  RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION BuscaRA() RETURNS INTEGER AS
$$
DECLARE
  result integer;
BEGIN
  SELECT RA INTO result FROM ALUNO ORDER BY RANDOM() LIMIT 1;
  RETURN result;
END;
$$ LANGUAGE plpgsql;
SELECT BuscaRA();
-- DROP FUNCTION BuscaRA();
-- SELECT RA FROM ALUNO ORDER BY RANDOM() LIMIT 1;

CREATE OR REPLACE FUNCTION BuscaPreReq() RETURNS TEXT AS
$$
DECLARE
  result TEXT;
BEGIN
  SELECT Sigla INTO result FROM Discip ORDER BY RANDOM() LIMIT 1;
  RETURN result;
END;
$$ LANGUAGE plpgsql;
SELECT BuscaPreReq();

CREATE OR REPLACE FUNCTION GeraNasc() RETURNS DATE AS
$$
BEGIN
  RETURN date(timestamp '1980-01-01 00:00:00' +  random() * (timestamp '2005-05-04 00:00:00' - timestamp '1980-01-01 00:00:00'));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GeraEstado() RETURNS TEXT AS
$$
DECLARE
  varEstado varchar[] = '{"AC", "AL", "AP", "AM", "BA", "CE", "ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC", "SP", "SE", "TO", "DF"}';
  result text := '';
BEGIN
  result := varEstado[FLOOR(random() * 26) + 1];
  RETURN result;
END;
$$ LANGUAGE plpgsql;
SELECT GeraEstado();

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

CREATE OR REPLACE FUNCTION GeraNota() RETURNS NUMERIC(3,1) AS
$$
DECLARE
  nota NUMERIC(3,1);
BEGIN
  nota := trunc(random() * 101) / 10;
  RETURN nota;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GeraFreq() RETURNS DECIMAL AS
$$
DECLARE
  freq DECIMAL;
BEGIN
  freq := (random() * 1000) / 10;
  RETURN freq;
END;
$$ LANGUAGE plpgsql;
SELECT GeraFreq();

-------------- Popular Aluno

DO $$
BEGIN 
  FOR i IN 1..10000 LOOP 
    INSERT INTO ALUNO (Nome, DataNasc, NomeMae, Cidade, Estado, Curso, Periodo)
    VALUES(GeraNome(10), GeraNasc(), GeraNome(10), GeraNome(15), GeraEstado(), GeraCurso(), GeraPeriodo()) ON conflict do nothing;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
ANALYZE Aluno;

-- SELECT * FROM ALUNO;
-------------- Popular Disciplina

DO $$
BEGIN 
-- Inserindo a primeira Disciplina para retornar valores em BuscaPreReq 
  INSERT INTO Discip (Sigla, Nome, NNCred, Depto)
  VALUES(GeraSigla(), GeraNomeDisciplina(), NumCredito(), GeraDept()) ON conflict do nothing;
  FOR i IN 1..250 LOOP 
    INSERT INTO Discip (Sigla, Nome, SiglaPreReq, NNCred, Monitor, Depto)
    VALUES(GeraSigla(), GeraNomeDisciplina(), BuscaPreReq(), NumCredito(), BuscaRA(), GeraDept()) ON conflict do nothing;
	INSERT INTO Discip (Sigla, Nome, NNCred, Depto)
    VALUES(GeraSigla(), GeraNomeDisciplina(), NumCredito(), GeraDept()) ON conflict do nothing;
	INSERT INTO Discip (Sigla, Nome, SiglaPreReq, NNCred, Depto)
    VALUES(GeraSigla(), GeraNomeDisciplina(), BuscaPreReq(), NumCredito(), GeraDept()) ON conflict do nothing;
	INSERT INTO Discip (Sigla, Nome, NNCred, Monitor, Depto)
    VALUES(GeraSigla(), GeraNomeDisciplina(), NumCredito(), BuscaRA(), GeraDept()) ON conflict do nothing;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
ANALYZE Discip;

-- SELECT * FROM Discip;
-------------- Popular Matricula

DO $$
DECLARE 
 aluno INTEGER;
BEGIN
  FOR i IN 1..2500 LOOP
  aluno = BuscaRA();
  FOR i IN 1..5 LOOP 
    INSERT INTO Matricula (RA, Sigla, Ano, Semestre, CodTurma, NotaP1, NotaP2, NotaTrab, Frequencia)
    VALUES(aluno, BuscaPreReq(), GeraAno(), GeraSemestre(), GeraCodTurma(), GeraNota(), GeraNota(), GeraNota(), GeraFreq()) ON conflict do nothing;
  END LOOP;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
ANALYZE Matricula;

-- SELECT * FROM Matricula;


------------------- Q2 
-- Suponha que o seguinte índice foi criado para a relação Aluno.
CREATE UNIQUE INDEX IdxAlunoNNP ON Aluno (Nome, NomeMae, Periodo);
-- O indexe foi modificado para um campo que possui mesmo tipo e que deverá conter varios alunos com mesmo valor assim como a Idade;
ANALYZE ALUNO;

 -- 1. Escreva uma consulta que utilize esse Índice.
SELECT * FROM ALUNO WHERE nome = 'joRBcRqEsF' AND nomemae = 'SUjXnynvnF' AND periodo = 9;
 -- 2. Mostre um exemplo onde o Índice não é usado mesmo utilizando algum campo indexado na cláusula where, e explique por quê
SELECT * FROM ALUNO WHERE nomemae = 'SUjXnynvnF' AND periodo = 9;
 
 -- Neste caso, mesmo o campo nomemae sendo parte do índice IdxAlunoNNP, o SGBD não irá utilizá-lo
 -- pois a consulta não especifica o valore da outra coluna (Nome) que também faz parte do índice. 
 -- O SGBD pode optar por não utilizar o índice se considerar que a utilização do mesmo não traria ganhos significativos de desempenho
 -- na busca dos registros desejados.
 -- Um ponto a ser considerado é a ordem dos atributos, como o indexe é formado por 2 campos varchar e somente por último um integer
 -- a arvore de indexação utilizara o primeiro campo como estrutura primaria para chave de folhas, como este campo não está na consulta
 -- podemos não ter uma busca simplificada neste caso.
 
------------------- Q3
-- Crie índices e mostre exemplos de consultas (resultados e explain) que usam os seguintes tipos de acessos:

-- a) Sequential Scan
EXPLAIN SELECT * FROM Matricula WHERE sigla = 'N7I8YFM'; 
-- Indice de chave primaria, porém não é utilizado já que a PK é composta e o primeiro atributo não é passado 
-- Para utilizar o index podemos fazer consultas como:
-- EXPLAIN SELECT * FROM Matricula WHERE RA = 2005; -- Utiliza Bitmap Heap Scan
-- EXPLAIN SELECT * FROM Matricula WHERE sigla = 'N7I8YFM' AND RA = 2005; -- Utiliza Index Scan

-- b) Bitmap Index Scan
CREATE EXTENSION btree_gin;
CREATE INDEX IdxDept ON Discip USING gin (Depto);
ANALYZE Discip;
EXPLAIN SELECT * FROM Discip WHERE Depto = 'DALET';

-- c) Index Scan
ANALYZE ALUNO;
EXPLAIN SELECT * FROM ALUNO WHERE RA = 2005;
-- Index secundario sem ser em chave primária
CREATE INDEX IdxCidade ON ALUNO (Cidade);
ANALYZE ALUNO;
EXPLAIN SELECT * FROM ALUNO WHERE Cidade = 'xiRpEgVwKjuaWOd'

-- d) Index-Only Scan
CREATE INDEX IdxPeriodoSP ON ALUNO (periodo) WHERE ESTADO = 'SP';
ANALYZE ALUNO;
EXPLAIN SELECT periodo FROM ALUNO WHERE Periodo = 9 AND Estado = 'SP';


-- e) Multi-Index Scan
EXPLAIN ANALYSE  SELECT A.RA, A.Nome, M.Ano, M.Semestre, M.CodTurma FROM Aluno A NATURAL JOIN Matricula M WHERE RA = 8587;
-- "Nested Loop  (cost=0.57..12.73 rows=5 width=27) (actual time=0.016..0.019 rows=5 loops=1)"
-- "  ->  Index Scan using registroacademico on aluno a  (cost=0.29..8.30 rows=1 width=15) (actual time=0.010..0.011 rows=1 loops=1)"
-- "        Index Cond: (ra = 8587)"
-- "  ->  Index Only Scan using matricula_pkey on matricula m  (cost=0.29..4.37 rows=5 width=16) (actual time=0.004..0.005 rows=5 loops=1)"
-- "        Index Cond: (ra = 8587)"
-- "        Heap Fetches: 0"
-- "Planning Time: 0.117 ms"
-- "Execution Time: 0.037 ms"


------------------- Q4 
-- Faça consutas com junções entre as tabelas e mostre o desempenho criando-se índices para cada chave estrangeira.
EXPLAIN ANALYZE SELECT * FROM MATRICULA m JOIN ALUNO a ON m.ra = a.ra WHERE m.ra = 34;
-- "Nested Loop  (cost=4.61..29.73 rows=5 width=106) (actual time=0.910..0.916 rows=5 loops=1)"
-- "  ->  Index Scan using registroacademico on aluno a  (cost=0.29..8.30 rows=1 width=60) (actual time=0.007..0.008 rows=1 loops=1)"
-- "        Index Cond: (ra = 34)"
-- "  ->  Bitmap Heap Scan on matricula m  (cost=4.32..21.37 rows=5 width=46) (actual time=0.898..0.899 rows=5 loops=1)"
-- "        Recheck Cond: (ra = 34)"
-- "        Heap Blocks: exact=1"
-- "        ->  Bitmap Index Scan on matricula_pkey  (cost=0.00..4.32 rows=5 width=0) (actual time=0.893..0.893 rows=5 loops=1)"
-- "              Index Cond: (ra = 34)"
-- "Planning Time: 1.237 ms"
-- "Execution Time: 0.946 ms"
CREATE INDEX IdxFkSigla ON Matricula (Sigla);
CREATE INDEX IdxFkRA ON Matricula (RA);
ANALYZE MATRICULA;

EXPLAIN ANALYZE SELECT * FROM MATRICULA m JOIN ALUNO a ON m.ra = a.ra WHERE m.ra = 34;

-- "Nested Loop  (cost=4.61..29.73 rows=5 width=106) (actual time=0.036..0.039 rows=5 loops=1)"
-- "   ->  Index Scan using registroacademico on aluno a  (cost=0.29..8.30 rows=1 width=60) (actual time=0.006..0.006 rows=1 loops=1)"
-- "        Index Cond: (ra = 34)"
-- "  ->  Bitmap Heap Scan on matricula m  (cost=4.32..21.37 rows=5 width=46) (actual time=0.025..0.026 rows=5 loops=1)"
-- "        Recheck Cond: (ra = 34)"
-- "        Heap Blocks: exact=1"
-- "        ->  Bitmap Index Scan on idxfkra  (cost=0.00..4.32 rows=5 width=0) (actual time=0.022..0.022 rows=5 loops=1)"
-- "              Index Cond: (ra = 34)"
-- "Planning Time: 0.350 ms"
-- "Execution Time: 0.063 ms"

-- É possível ver que os indexes auxiliam na busca, contudo durante a inserção isso pode gerar um atraso. Importante notar o trade-off
------------------- Q5
-- Utilize um índice bitmap para o período e mostre-o em uso nas consultas

CREATE INDEX IdxPeriodoBitmap ON aluno USING gin (periodo);
ANALYZE ALUNO;
EXPLAIN SELECT * FROM ALUNO WHERE periodo = 4;
EXPLAIN SELECT * FROM ALUNO WHERE periodo = 4 AND curso = 'ENGMEC';

------------------- Q6
-- Compare na prática o custo de executar uma consulta com e sem um índice clusterizado na tabela aluno. 
-- Ou seja, faça uma consulta sobre algum dado indexado, clusterize a tabela naquele índice e refaça a consulta.
-- Mostre os comandos e os resultados do exlain analyze.

EXPLAIN ANALYZE SELECT * FROM ALUNO WHERE nome = 'BbPypeULcb';
-- "Index Scan using idxalunonnp on aluno  (cost=0.29..8.30 rows=1 width=60) (actual time=0.879..0.880 rows=1 loops=1)"
-- "  Index Cond: ((nome)::text = 'BbPypeULcb'::text)"
-- "Planning Time: 0.072 ms"
-- "Execution Time: 0.894 ms"

ALTER TABLE ALUNO CLUSTER ON idxalunonnp;
CLUSTER ALUNO;
ANALYZE ALUNO;
EXPLAIN ANALYZE SELECT * FROM ALUNO WHERE nome = 'BbPypeULcb';
-- "Index Scan using idxalunonnp on aluno  (cost=0.29..8.30 rows=1 width=60) (actual time=0.014..0.015 rows=1 loops=1)"
-- "  Index Cond: ((nome)::text = 'BbPypeULcb'::text)"
-- "Planning Time: 0.056 ms"
-- "Execution Time: 0.026 ms"

------------------- Q7
-- Acrescente um campo adicional na tabela de Aluno, chamado de informacoesExtras, do tipo JSON.
-- Insira dados diferentes telefônicos e de times de futebol que o aluno torce para cada aluno neste JSON.
-- Crie índices para o JSON e mostre consultas que o utiliza (explain analyze). 
-- Exemplo: retorne os alunos que torcem para o Internacional.

ALTER TABLE ALUNO ADD informacoesExtras jsonb;

CREATE OR REPLACE FUNCTION NumTelefone() RETURNS INTEGER AS
$$ 
BEGIN
  RETURN trunc(random() *  power(10,9));
END;
$$ LANGUAGE plpgsql;
SELECT NumTelefone();


-------- update aluno com jsons
DO $$
DECLARE tempRA INTEGER;
DECLARE times VARCHAR [] = '{"internacional", "são paulo", "grêmio", "palmeiras"}';
BEGIN 
  FOR i IN 1..2500 LOOP
    FOR j IN 1..4 LOOP
      tempRA = BuscaRA();
      UPDATE ALUNO SET informacoesExtras = (('{ "telefone" : '|| NumTelefone() ||', "time" : "'|| times [j] ||'"}')::json)
	  WHERE RA = tempRA;
    END LOOP;
  END LOOP;
END;
$$ language plpgsql;

ANALYZE ALUNO;

EXPLAIN ANALYZE SELECT informacoesextras FROM ALUNO WHERE informacoesextras->>'time' = 'internacional';

CREATE INDEX IdxTime ON ALUNO USING BTREE ((informacoesextras->>'time'));

EXPLAIN ANALYZE SELECT informacoesextras FROM ALUNO WHERE informacoesextras->>'time' = 'internacional';

CREATE INDEX IdxTimeGremio ON ALUNO USING BTREE ((informacoesextras->>'time')) WHERE informacoesextras->>'time' = 'grêmio';

EXPLAIN ANALYZE SELECT informacoesextras FROM ALUNO WHERE informacoesextras->>'time' = 'grêmio';

ALTER TABLE SQM_CONNECTIONS ADD (
  CONSTRAINT SQM_CON_PK PRIMARY KEY (ID));

ALTER TABLE SQM_CONNECTIONS ADD (
  CONSTRAINT SQM_CON_UK UNIQUE (CONNECTIONNAME));


ALTER TABLE SQM_QUERIES ADD (
  CONSTRAINT SQM_SQL_PK PRIMARY KEY (ID));

ALTER TABLE SQM_QUERIES ADD (
  CONSTRAINT SQM_SQL_UK UNIQUE (QUERYNAME));


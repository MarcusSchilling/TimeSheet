Alter table Tasks rename to temp_Tasks;
CREATE TABLE Tasks (name TEXT PRIMARY KEY, done REAL, start_date TEXT, end_date TEXT, initial_time REAL);
INSERT INTO Tasks(name, done, start_date, end_date, initial_time) Select name, initial_time - time, date, end_date, initial_time from temp_Tasks;
Drop table temp_Tasks
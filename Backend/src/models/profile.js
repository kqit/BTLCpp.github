const queryTableProfile=`
CREATE TABLE Profile (
    id_profile varchar(10) NOT NULL UNIQUE PRIMARY KEY REFERENCES users(id_profile),
    full_name varchar(30),
    weight real NOT NULL DEFAULT 0,
    height real NOT NULL DEFAULT 0,
    sex char(5),
    age integer,
    address varchar(40),
    avatar varchar(100) NOT NULL DEFAULT 'null'
);
`
module.exports = queryTableProfile
const queryTableUser=`
CREATE TABLE Users (
    id char(10) NOT NULL UNIQUE PRIMARY KEY,
    username varchar(30) NOT NULL UNIQUE,
    password varchar(30) NOT NULL,
    id_profile varchar NOT NULL UNIQUE,
    id_target varchar NOT NULL UNIQUE,
    id_schedule varchar NOT NULL UNIQUE
     
);
`
module.exports = queryTableUser
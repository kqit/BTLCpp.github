const queryTableTarget=`
CREATE TABLE Target (
    id_target varchar(10) NOT NULL REFERENCES users(id_target),
    calo integer,
    cacbohydrate integer,
    protein integer,
    lipit integer,
    times date
);
`
module.exports = queryTableTarget
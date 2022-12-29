const queryTableSession=`
CREATE TABLE Session (
    id_session varchar REFERENCES Schedule(id_session),
    id_tag varchar NOT NULL UNIQUE
);
`
module.exports = queryTableSession
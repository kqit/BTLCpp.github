const queryTableTag=`
CREATE TABLE Tag (
    id_tag varchar REFERENCES Session(id_tag),
    id_food varchar,
    mass float4
    );
`
module.exports = queryTableTag
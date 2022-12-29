const queryTableFood=`
CREATE TABLE Food (
    id_food varchar NOT NULL UNIQUE PRIMARY KEY,
    name varchar(30),
    calo_per_100gr float,
    lipit_per_100gr float,
    cacbohydrate_per_100gr float,
    protein_per_100gr float
);
`
module.exports = queryTableFood
const queryTableSchedule=`
CREATE TABLE Schedule (
    id_schedule varchar REFERENCES users(id_schedule),
    times date,
    id_session varchar NOT NULL UNIQUE
);
`
module.exports = queryTableSchedule
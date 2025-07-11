\i schema.sql

\i seed.sql

\i sample_data.sql

\i functions.sql

\i triggers.sql

\i views.sql

\i permissions.sql

DO $$
BEGIN
    RAISE NOTICE 'Arquivos criados: schema.sql, seed.sql, sample_data.sql, functions.sql, triggers.sql, views.sql, permissions.sql';
END $$; 
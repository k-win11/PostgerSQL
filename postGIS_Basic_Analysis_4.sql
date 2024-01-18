CREATE TABLE online_courses
(
  id SERIAL PRIMARY KEY, 
  title TEXT NOT NULL, 
  description TEXT NOT NULL
);

INSERT INTO online_courses (title, description) VALUES
  ('Learning Java', 'A complete course that will help you learn Java in simple steps'),
  ('Advanced Java', 'Master advanced topics in Java, with hands-on examples'),
  ('Introduction to Machine Learning', 'Build and train simple machine learning models'),
  ('Learning Springboot', 'Build web applications in Java using SpringBoot'),
  ('Learning TensorFlow', 'Build and train deep learning models using TensorFlow 2.0'),
  ('Learning PyTorch', 'Build and train deep learning models using PyTorch'),
  ('Introduction to Self-supervised Machine Learning', 'Learn more from your unlabelled data'),
  ('Data Analytics and Visualization', 'Visualize, understand, and explore data using Python'),
  ('Learning SQL', 'Learn SQL programming in 21 days'),
  ('Learning C++', 'Take your first steps in C++ programming'),
  ('Learning Python', 'Take your first steps in Python programming'),
  ('Learning PostgreSQL', 'SQL programming using the PostgreSQL object-relational database'),
  ('Advanced PostgreSQL', 'Master advanced features in PostgreSQL');--view ta 
 
 --view table 
SELECT *FROM online_courses;
 
 --searching text from table
SELECT 
    id,
    title,
    description
FROM 
    online_courses
	WHERE  
    title LIKE '%Java%' OR description LIKE '%Java%';
	
--Let's use the ILIKE which is case-insensitive
SELECT 
    id,
    title,
    description
FROM 
    online_courses
WHERE  
    title ILIKE '%java%' OR description ILIKE '%java%';
-----------



--data clening
--------------------------------	
--vectore data reperesntation 
SELECT to_tsvector('Visualize, understand, and explore data using Python');
--the result is a list of lexemes ready to be searched
--stop words ("in", "a", "the", etc) were removed
--the numbers are the position of the lexemes in the document
--o/p with remove stop word and word in list with position 

SELECT to_tsquery('The & machine & learning');
-- the result is a list of tokens ready to be queried
-- stop words ("in", "a", "the", etc) were removed

--This will return "true"
SELECT 'machine & learning'::tsquery @@ 'Build and train simple machine learning models'::tsvector;

--This will return "false"
SELECT 'deep & learning'::tsquery @@ 'Build and train simple machine learning models'::tsvector;


--This will return "true"
SELECT 'Build and train simple machine learning models'::tsvector @@ 'models'::tsquery;

--This will return "false"
SELECT 'Build and train simple machine learning models'::tsvector @@ 'deep'::tsquery;


--You can use a tsquery to search against a tsvector or plain text


-- This will return "true"
SELECT to_tsquery('learning & model') @@ to_tsvector('Build and train simple machine learning models');

-- This will return "false"
SELECT to_tsquery('learning & model') @@ 'Build and train simple machine learning models';

SET default_text_search_config = 'pg_catalog.spanish';

SELECT to_tsvector('english', 'The cake is good');
SELECT to_tsvector('spanish', 'The cake is good');
SELECT to_tsvector('simple', 'The cake is good');

SELECT to_tsvector('english', 'el pastel es bueno');
SELECT to_tsvector('spanish', 'el pastel es bueno');
SELECT to_tsvector('simple', 'el pastel es bueno');



--Let's search a word that's not present

SELECT to_tsvector(
  'Bienvenido al tutorial de PostgreSQL.' ||
  'PostgreSQL se utiliza para almacenar datos.' ||
  'tener una buena experiencia!'
) @@ to_tsquery('mala');
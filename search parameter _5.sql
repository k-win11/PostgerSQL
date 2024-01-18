CREATE TABLE documents  
(
    document_id SERIAL,
    document_text TEXT,
    document_tokens TSVECTOR,

    CONSTRAINT documents_pkey PRIMARY KEY (document_id));

--Now let's insert the documents into it
INSERT INTO documents (document_text) VALUES  
('The greatest glory in living lies not in never falling, but in rising every time we fall. -Nelson Mandela'),
('The way to get started is to quit talking and begin doing. -Walt Disney'),
('When you reach the end of your rope, tie a knot in it and hang on. -Franklin D. Roosevelt'),
('Never let the fear of striking out keep you from playing the game. -Babe Ruth'),
('You have brains in your head. You have feet in your shoes. You can steer yourself any direction you choose. -Dr. Seuss'),
('Life is a long lesson in humility. -James M. Barrie');

--view table 
select *from documents;

UPDATE documents d1  
SET document_tokens = to_tsvector(d1.document_text)  
FROM documents d2;

SELECT document_id, document_text, document_tokens FROM documents
WHERE document_tokens @@ websearch_to_tsquery('begin doing'); 


SELECT document_id, document_text, document_tokens FROM documents
WHERE document_tokens @@ to_tsquery('hang & on'); 


--There should be one document in the result


SELECT document_id, document_text, document_tokens FROM documents
WHERE document_tokens @@ to_tsquery('long <-> lesson'); 


--One document with the term "long lesson"


SELECT document_id, document_text, document_tokens FROM documents
WHERE document_tokens @@ to_tsquery('direction <2> choose'); 

--One document with "direction you choose"


SELECT document_id, document_text, document_tokens FROM documents
WHERE document_tokens @@ to_tsquery('fear <3> out'); 
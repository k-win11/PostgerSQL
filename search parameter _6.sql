
--Simple Dictionaries

CREATE TEXT SEARCH DICTIONARY public.simple_dict (
    TEMPLATE = pg_catalog.simple,
    STOPWORDS = english
);

SELECT ts_lexize('public.simple_dict', 'Shoes');

--It will return the following

 ts_lexize
-----------
 {shoes}


SELECT ts_lexize('public.simple_dict', 'The');

--It will return following result because it is a stop word

 ts_lexize
-----------
 {}

--Let's try the following one to see of is a stop word or not

SELECT ts_lexize('public.simple_dict', 'of');


--Above query will return empty because those are the stop words


-- We can also choose to return NULL, instead of the lower-cased word, 
--if it is not found in the stop words file. 

--Alternatively, the dictionary can be configured to report non-stop-words as unrecognized, allowing them to be passed on to the next dictionary in the list.
--This behavior is selected by setting the dictionary's Accept parameter to false.

ALTER TEXT SEARCH DICTIONARY public.simple_dict ( Accept = false );

--Run following query to search

SELECT ts_lexize('public.simple_dict', 'Shoes');

--Run following query

SELECT ts_lexize('public.simple_dict', 'ShoeS');

--Run following query

SELECT ts_lexize('public.simple_dict', 'The');

 # default setting of Accept = true, 
 # it is only useful to place a simple dictionary at the end of a list of dictionaries, 
 # since it will never pass on any token to a following dictionary.







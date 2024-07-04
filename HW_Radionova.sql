--Создание таблиц

CREATE TABLE IF NOT EXISTS Genre (
	id SERIAL PRIMARY KEY,
	title VARCHAR(60) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Musician (
	id SERIAL PRIMARY KEY,
	name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Album (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) UNIQUE NOT NULL,
	release_date date check(release_date>'1969.12.31')
);

CREATE TABLE IF NOT EXISTS MusicTrack (
	id SERIAL PRIMARY KEY,
	album_id INTEGER NOT NULL REFERENCES Album(id),
	title VARCHAR(120) UNIQUE NOT NULL,
	duration INTEGER NOT null check(duration<360)
);

CREATE TABLE IF NOT EXISTS Collection (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) UNIQUE NOT NULL,
	release_date date check(release_date>'1969.12.31')
);


CREATE TABLE IF NOT EXISTS GenreMusician (
	genre_id INTEGER REFERENCES Genre(id),
	musician_id INTEGER REFERENCES Musician(id),
	CONSTRAINT gm PRIMARY KEY (genre_id, musician_id)
);

CREATE TABLE IF NOT EXISTS MusicianAlbum (
	musician_id INTEGER REFERENCES Musician(id),
	album_id INTEGER REFERENCES Album(id),
	CONSTRAINT ma PRIMARY KEY (musician_id, album_id)
);

CREATE TABLE IF NOT EXISTS TrackCollection (
	musictrack_id INTEGER REFERENCES MusicTrack(id),
	collection_id INTEGER REFERENCES Collection(id),
	CONSTRAINT tc PRIMARY KEY (musictrack_id, collection_id)
);

CREATE TABLE IF NOT EXISTS TrackMusician (
	musictrack_id INTEGER REFERENCES MusicTrack(id),
	musician_id INTEGER REFERENCES Musician(id),
	CONSTRAINT tm PRIMARY KEY (musictrack_id, musician_id)
);


--Задание 1

INSERT INTO genre (title)
VALUES
('Хип-хоп'),
('RnB'),
('Рок'),
('Регги'),
('Блюз');

INSERT INTO musician (name)
VALUES
('Eminem'),
('Snoop Dogg'),
('Jay-Z'),
('Rihanna'),
('Linkin Park'),
('Coldplay'),
('Panic! at the Disco'),
('Bob Marley'),
('Shaggy'),
('B.B. King'),
('Etta James'),
('Alabama Shakes'),
('Dr. Dre'),
('Elephant man')
;

INSERT INTO album(name, release_date) 
VALUES
('Recovery', '2010.06.21'),
('2001', '1999.12.16'),
('Good Girl Gone Bad', '2007.05.30'),
('Music Of The Spheres', '2021.10.15'),
('Loud', '2010.11.12'),
('Fridays For Future', '2019.10.01'),
('Riding with the King', '2000.06.13'),
('Music Of The Sun', '2005.08.26'),
('The Black AlbumA Cappella','2004.01.01')
;

INSERT INTO musictrack(album_id, title, duration) 
VALUES
(1, 'Love The Way You Lie', 264),
(2, 'Still D.R.E.', 270),
(3, 'Umbrella', 276),
(4, 'Humankind', 266),
(5, 'S&M', 243),
(7, 'Ten long years', 168),
(10, 'The Soul Of A Man', 193),
(8, 'Pon De Replay', 185),
(10, 'Diamonds', 225),
(9, 'My 1st Song', 285),
(6, 'One Love / People Get Ready', 173),
(6, 'Natural Mystic', 207)
;

INSERT INTO collection (name, release_date) 
VALUES
('Discover More Hip Hop', '2008.01.01'),
('R&B The Collection Summer 2011', '2011.06.01'),
('Top Music Non Stop vol.3', '2013.01.01'),
('Hip Hop: The Collection 2008', '2008.01.01'),
('Discover More Soul', '2020.01.01')
;

INSERT INTO genremusician (genre_id , musician_id) 
VALUES
(1,1),
(1,2),
(1,3),
(2,3),
(2,4),
(3,5),
(3,6),
(3,7),
(4,8),
(4,9),
(5,10),
(5,11),
(5,12),
(1,13),
(4,14)
;

INSERT INTO musicianalbum (musician_id, album_id) 
VALUES
(1,1),
(13,2),
(4,3),
(6,4),
(4,5),
(8,6),
(10,7),
(12,7),
(4,8),
(14,8),
(3,9)
;

INSERT INTO trackcollection (musictrack_id, collection_id) 
VALUES
(1,1),
(2,1),
(5,2),
(9,3),
(2,4)
;

INSERT into trackmusician (musictrack_id, musician_id) 
VALUES
(1,4),
(1,1),
(2,2),
(2,13),
(3,3),
(3,4),
(4,6),
(5,4),
(6,10),
(7,11),
(8,4),
(8,14),
(9,4),
(10,3),
(11,8),
(12,8)
;


--Задание 2
SELECT title t, duration d FROM musictrack m
ORDER BY d DESC 
LIMIT 1;

SELECT title t FROM musictrack m
WHERE duration>210;

SELECT name, release_date FROM collection c
WHERE release_date BETWEEN '2018.01.01' AND '2020.12.31';

SELECT name FROM musician m 
WHERE name NOT LIKE '% %';

SELECT title FROM musictrack 
WHERE LOWER(title) LIKE LOWER('%my%') OR LOWER(title) LIKE LOWER('%мой%');


--Задание 3

SELECT title, count(name) FROM genremusician gm 
JOIN genre g ON gm.genre_id = g.id
JOIN musician m ON gm.musician_id = m.id
GROUP BY title
ORDER BY count DESC 

SELECT name, count(title) FROM musictrack m2 
JOIN album a ON m2.album_id = a.id
WHERE release_date BETWEEN '2019.01.01' AND '2020.12.31'
GROUP BY name

SELECT name, AVG(duration) FROM musictrack m 
JOIN album a ON m.album_id = a.id
GROUP BY name

SELECT mu.name, al.name FROM musicianalbum ma 
JOIN musician mu ON ma.musician_id = mu.id
JOIN album al ON ma.album_id = al.id
WHERE al.release_date NOT BETWEEN '2020.01.01' AND '2020.12.31'

SELECT c.name FROM trackcollection t 
JOIN musictrack mt ON t.musictrack_id = mt.id
JOIN collection c ON t.collection_id = c.id
JOIN trackmusician t2 ON t.musictrack_id = t2.musictrack_id 
JOIN musician m2 ON t2.musician_id = m2.id
WHERE m2.name = 'Rihanna'


--Задание 4

SELECT m2.name FROM musicianalbum m 
JOIN musician m2 ON m.musician_id = m2.id
JOIN album a ON m.album_id = a.id
JOIN genremusician gm ON m.musician_id = gm.musician_id 
JOIN genre g ON gm.genre_id = g.id
GROUP BY m2.name
HAVING COUNT(title) > 1

SELECT title FROM musictrack m 
LEFT JOIN trackcollection t ON m.id = t.musictrack_id 
WHERE collection_id IS NULL

SELECT name, duration FROM trackmusician t 
JOIN musician m ON t.musician_id = m.id 
JOIN musictrack m2 ON t.musictrack_id =m2.id
WHERE duration = (SELECT MIN(duration) FROM musictrack)

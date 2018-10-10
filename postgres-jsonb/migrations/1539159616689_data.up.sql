--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Ubuntu 10.4-2.pgdg14.04+1)
-- Dumped by pg_dump version 10.5 (Ubuntu 10.5-0ubuntu0.18.04)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.product (uuid, name, description, price, spec, category) VALUES ('b03592fd-4040-4255-b9ba-076ebffceb9d', 'Dell XPS 13', 'The world''s smallest 13-inch laptop with captivating Dell Cinema and next-gen InfinityEdge. Featuring an 8th Gen Intel® Quad Core processor in a stunning new look.', 68642.8100, '{"os": "Windows 10 Home 64-bit English", "ram": "4GB", "disk": "128GB", "weight": "1.2kg", "battery": "52WHr", "display": "13.3in", "processor": "8th Generation Intel® Core™ i5-8250U"}', 'Laptop');
INSERT INTO public.product (uuid, name, description, price, spec, category) VALUES ('e2762490-33e5-4183-ada0-673ad4b67f0c', 'Dell XPS 13', 'The world''s smallest 13-inch laptop with captivating Dell Cinema and next-gen InfinityEdge. Featuring an 8th Gen Intel® Quad Core processor in a stunning new look.', 72074.9900, '{"os": "Windows 10 Home 64-bit English", "ram": "8GB", "disk": "256GB", "weight": "1.2kg", "battery": "52WHr", "display": "13.3in", "processor": "8th Generation Intel® Core™ i5-8250U"}', 'Laptop');
INSERT INTO public.product (uuid, name, description, price, spec, category) VALUES ('4e69b881-fe40-43f0-919e-db4187f45bab', 'Moto G6 Play', 'Never have a dull moment with the Moto G6 Play smartphone by your side. The Qualcomm Snapdragon 430 Processor, along with its 14.5 cm (5.7) HD+ 18:9 Max Vision Display, lets you do a lot more than just the usual surfing and texting, such as playing graphics-heavy games seamlessly. Take advantage of its great front and rear cameras to click beautiful pictures. ', 11999, '{"os": "Android Oreo 8.1", "gpu": "450 MHz Adreno 505", "ram": "3GB", "screen": "5.7in", "battery": "4000mAh", "storage": "32GB", "sim_type": "Dual SIM", "processor": "Qualcomm Snapdragon 430"}', 'Mobile');
INSERT INTO public.product (uuid, name, description, price, spec, category) VALUES ('13218e8d-462c-471a-a80d-83579a205094', 'Xiaomi Mi A1', 'The Xiaomi Mi A1 is an Android One phone that is powered by Google itself. So not only do you get near-stock Android Nougat out of the box, but you are also guaranteed OS upgrades. Further, Android One device is also one of the first to get the upgrade.', 15990, '{"os": "Android Nougat 7.1.2", "gpu": "Adreno 506", "ram": "4GB", "color": "Rose Gold", "screen": "5.5in", "battery": "3080mAh", "storage": "64GB", "sim_type": "Dual SIM", "processor": "Qualcomm Snapdragon 625 64 bit Octa Core 2GHz", "primary_camera": "12MP+12MP", "secondary_camera": "5MP"}', 'Mobile');
INSERT INTO public.product (uuid, name, description, price, spec, category) VALUES ('bd87e236-a2b7-4dff-8e3f-9453ea8bd995', 'Peter England University Men''s Solid Casual Spread Shirt', 'Casual Shirt', 493, '{"fit": "Slim Fit", "size": 38, "fabric": "Cotton", "sleeve": "Full Sleeve", "pattern": "Solid", "collar_type": "Spread", "fabric_care": "Regular Machine Wash, Reverse and dry, Dry in shade, Do not bleach"}', 'Shirt');
INSERT INTO public.product (uuid, name, description, price, spec, category) VALUES ('09cf633b-a34c-45cc-ad59-3273e3ad65f3', 'Skullcandy Ink''d Headset with mic', 'Invest in these Skullcandy Ink''d earphones and enjoy listening to music in a high-quality audio reproduction. It comes with Supreme Sound technology that ensures deep and powerful bass to take your music to a new level', 799, '{"type": "In the ear", "color": "Black & Red", "controls": ["Play", "Pause", "Next", "Previous", "Answer Calls"], "impedence": "16Ohm", "model_name": "S2IKDY-010", "magner_type": "Neodymium", "connectivity": "Wired", "min_freq_response": "18Hz", "frequency_response": {"max": "20000Hz"}}', 'Earphones');
INSERT INTO public.product (uuid, name, description, price, spec, category) VALUES ('73c4972f-19d6-4631-ada5-c80f1a00522b', 'HP 15q', 'HP 15q Core i3 7th Gen - (4 GB/1 TB HDD/Windows 10 Home) 15q-bu040tu Laptop  (15.6 inch, Sparkling Black, 1.86 kg)', 27990, '{"os": "Windows 10 Home 64-bit English", "ram": "4GB", "disk": "1TB", "weight": "1.86kg", "battery": "4cell", "display": "15.6in", "processor": "7th Generation Intel® Core™ i3"}', 'Laptop');
INSERT INTO public.product (uuid, name, description, price, spec, category) VALUES ('8dcd6ea3-831c-40d9-9ed6-cce314abe59d', 'Apple MacBook Air', 'Apple MacBook Air Core i5 5th Gen - (8 GB/128 GB SSD/Mac OS Sierra) MQD32HN/A A1466  (13.3 inch, SIlver, 1.35 kg)', 57990, '{"os": "Mac OS Sierra", "ram": "8GB", "disk": "128GB", "weight": "1.35kg", "battery": "12hours", "display": "13.3in", "processor": "5th Generation Intel® Core™ i5"}', 'Laptop');


--
-- PostgreSQL database dump complete
--


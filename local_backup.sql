--
-- PostgreSQL database dump
--

\restrict czTSE2BIYFGoHJ4Q4WSQB1Ad2HoFhBAjdU8o8IIIoOT9L9VkgGVwaj5VmylAAWq

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: pokemon_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pokemon_details (
    id integer NOT NULL,
    name text NOT NULL,
    height integer,
    base_experience integer,
    is_default boolean,
    power double precision,
    weight double precision
);


ALTER TABLE public.pokemon_details OWNER TO postgres;

--
-- Name: pokemon_sprites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pokemon_sprites (
    pokemon_id integer NOT NULL,
    front_default text,
    front_shiny text,
    back_default text,
    back_shiny text,
    official_artwork text
);


ALTER TABLE public.pokemon_sprites OWNER TO postgres;

--
-- Name: pokemon_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pokemon_stats (
    pokemon_id integer,
    stat_name character varying(50),
    base_stat integer,
    effort integer
);


ALTER TABLE public.pokemon_stats OWNER TO postgres;

--
-- Name: pokemon_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pokemon_types (
    id integer NOT NULL,
    pokemon_id integer,
    type_name character varying(50),
    slot integer
);


ALTER TABLE public.pokemon_types OWNER TO postgres;

--
-- Name: pokemon_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pokemon_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pokemon_types_id_seq OWNER TO postgres;

--
-- Name: pokemon_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pokemon_types_id_seq OWNED BY public.pokemon_types.id;


--
-- Name: pokemons_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pokemons_list (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    api_url text NOT NULL
);


ALTER TABLE public.pokemons_list OWNER TO postgres;

--
-- Name: pokemons_list_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pokemons_list_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pokemons_list_id_seq OWNER TO postgres;

--
-- Name: pokemons_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pokemons_list_id_seq OWNED BY public.pokemons_list.id;


--
-- Name: pokemon_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon_types ALTER COLUMN id SET DEFAULT nextval('public.pokemon_types_id_seq'::regclass);


--
-- Name: pokemons_list id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemons_list ALTER COLUMN id SET DEFAULT nextval('public.pokemons_list_id_seq'::regclass);


--
-- Data for Name: pokemon_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pokemon_details (id, name, height, base_experience, is_default, power, weight) FROM stdin;
1	bulbasaur	7	64	t	\N	69
2	ivysaur	10	142	t	\N	130
3	venusaur	20	236	t	\N	1000
4	charmander	6	62	t	\N	85
5	charmeleon	11	142	t	\N	190
6	charizard	17	240	t	\N	905
7	squirtle	5	63	t	\N	90
8	wartortle	10	142	t	\N	225
9	blastoise	16	239	t	\N	855
10	caterpie	3	39	t	\N	29
11	metapod	7	72	t	\N	99
12	butterfree	11	178	t	\N	320
13	weedle	3	39	t	\N	32
14	kakuna	6	72	t	\N	100
15	beedrill	10	178	t	\N	295
16	pidgey	3	50	t	\N	18
17	pidgeotto	11	122	t	\N	300
18	pidgeot	15	216	t	\N	395
19	rattata	3	51	t	\N	35
20	raticate	7	145	t	\N	185
21	spearow	3	52	t	\N	20
22	fearow	12	155	t	\N	380
23	ekans	20	58	t	\N	69
24	arbok	35	157	t	\N	650
25	pikachu	4	112	t	\N	60
26	raichu	8	218	t	\N	300
27	sandshrew	6	60	t	\N	120
28	sandslash	10	158	t	\N	295
29	nidoran-f	4	55	t	\N	70
30	nidorina	8	128	t	\N	200
31	nidoqueen	13	227	t	\N	600
32	nidoran-m	5	55	t	\N	90
33	nidorino	9	128	t	\N	195
34	nidoking	14	227	t	\N	620
35	clefairy	6	113	t	\N	75
36	clefable	13	217	t	\N	400
37	vulpix	6	60	t	\N	99
38	ninetales	11	177	t	\N	199
39	jigglypuff	5	95	t	\N	55
40	wigglytuff	10	196	t	\N	120
41	zubat	8	49	t	\N	75
42	golbat	16	159	t	\N	550
43	oddish	5	64	t	\N	54
44	gloom	8	138	t	\N	86
45	vileplume	12	221	t	\N	186
46	paras	3	57	t	\N	54
47	parasect	10	142	t	\N	295
48	venonat	10	61	t	\N	300
49	venomoth	15	158	t	\N	125
50	diglett	2	53	t	\N	8
51	dugtrio	7	149	t	\N	333
52	meowth	4	58	t	\N	42
53	persian	10	154	t	\N	320
54	psyduck	8	64	t	\N	196
55	golduck	17	175	t	\N	766
56	mankey	5	61	t	\N	280
57	primeape	10	159	t	\N	320
58	growlithe	7	70	t	\N	190
59	arcanine	19	194	t	\N	1550
60	poliwag	6	60	t	\N	124
61	poliwhirl	10	135	t	\N	200
62	poliwrath	13	230	t	\N	540
63	abra	9	62	t	\N	195
64	kadabra	13	140	t	\N	565
65	alakazam	15	225	t	\N	480
66	machop	8	61	t	\N	195
67	machoke	15	142	t	\N	705
68	machamp	16	227	t	\N	1300
69	bellsprout	7	60	t	\N	40
70	weepinbell	10	137	t	\N	64
71	victreebel	17	221	t	\N	155
72	tentacool	9	67	t	\N	455
73	tentacruel	16	180	t	\N	550
74	geodude	4	60	t	\N	200
75	graveler	10	137	t	\N	1050
76	golem	14	223	t	\N	3000
77	ponyta	10	82	t	\N	300
78	rapidash	17	175	t	\N	950
79	slowpoke	12	63	t	\N	360
80	slowbro	16	172	t	\N	785
81	magnemite	3	65	t	\N	60
82	magneton	10	163	t	\N	600
83	farfetchd	8	132	t	\N	150
84	doduo	14	62	t	\N	392
85	dodrio	18	165	t	\N	852
86	seel	11	65	t	\N	900
87	dewgong	17	166	t	\N	1200
88	grimer	9	65	t	\N	300
89	muk	12	175	t	\N	300
90	shellder	3	61	t	\N	40
91	cloyster	15	184	t	\N	1325
92	gastly	13	62	t	\N	1
93	haunter	16	142	t	\N	1
94	gengar	15	225	t	\N	405
95	onix	88	77	t	\N	2100
96	drowzee	10	66	t	\N	324
97	hypno	16	169	t	\N	756
98	krabby	4	65	t	\N	65
99	kingler	13	166	t	\N	600
100	voltorb	5	66	t	\N	104
101	electrode	12	172	t	\N	666
102	exeggcute	4	65	t	\N	25
103	exeggutor	20	186	t	\N	1200
104	cubone	4	64	t	\N	65
105	marowak	10	149	t	\N	450
106	hitmonlee	15	159	t	\N	498
107	hitmonchan	14	159	t	\N	502
108	lickitung	12	77	t	\N	655
109	koffing	6	68	t	\N	10
110	weezing	12	172	t	\N	95
111	rhyhorn	10	69	t	\N	1150
112	rhydon	19	170	t	\N	1200
113	chansey	11	395	t	\N	346
114	tangela	10	87	t	\N	350
115	kangaskhan	22	172	t	\N	800
116	horsea	4	59	t	\N	80
117	seadra	12	154	t	\N	250
118	goldeen	6	64	t	\N	150
119	seaking	13	158	t	\N	390
120	staryu	8	68	t	\N	345
121	starmie	11	182	t	\N	800
122	mr-mime	13	161	t	\N	545
123	scyther	15	100	t	\N	560
124	jynx	14	159	t	\N	406
125	electabuzz	11	172	t	\N	300
126	magmar	13	173	t	\N	445
127	pinsir	15	175	t	\N	550
128	tauros	14	172	t	\N	884
129	magikarp	9	40	t	\N	100
130	gyarados	65	189	t	\N	2350
131	lapras	25	187	t	\N	2200
132	ditto	3	101	t	\N	40
133	eevee	3	65	t	\N	65
134	vaporeon	10	184	t	\N	290
135	jolteon	8	184	t	\N	245
136	flareon	9	184	t	\N	250
137	porygon	8	79	t	\N	365
138	omanyte	4	71	t	\N	75
139	omastar	10	173	t	\N	350
140	kabuto	5	71	t	\N	115
141	kabutops	13	173	t	\N	405
142	aerodactyl	18	180	t	\N	590
143	snorlax	21	189	t	\N	4600
144	articuno	17	261	t	\N	554
145	zapdos	16	261	t	\N	526
146	moltres	20	261	t	\N	600
147	dratini	18	60	t	\N	33
148	dragonair	40	147	t	\N	165
149	dragonite	22	270	t	\N	2100
150	mewtwo	20	306	t	\N	1220
151	mew	4	270	t	\N	40
152	chikorita	9	64	t	\N	64
153	bayleef	12	142	t	\N	158
154	meganium	18	236	t	\N	1005
155	cyndaquil	5	62	t	\N	79
156	quilava	9	142	t	\N	190
157	typhlosion	17	240	t	\N	795
158	totodile	6	63	t	\N	95
159	croconaw	11	142	t	\N	250
160	feraligatr	23	239	t	\N	888
161	sentret	8	43	t	\N	60
162	furret	18	145	t	\N	325
163	hoothoot	7	52	t	\N	212
164	noctowl	16	158	t	\N	408
165	ledyba	10	53	t	\N	108
166	ledian	14	137	t	\N	356
167	spinarak	5	50	t	\N	85
168	ariados	11	140	t	\N	335
169	crobat	18	241	t	\N	750
170	chinchou	5	66	t	\N	120
171	lanturn	12	161	t	\N	225
172	pichu	3	41	t	\N	20
173	cleffa	3	44	t	\N	30
174	igglybuff	3	42	t	\N	10
175	togepi	3	49	t	\N	15
176	togetic	6	142	t	\N	32
177	natu	2	64	t	\N	20
178	xatu	15	165	t	\N	150
179	mareep	6	56	t	\N	78
180	flaaffy	8	128	t	\N	133
181	ampharos	14	230	t	\N	615
182	bellossom	4	221	t	\N	58
183	marill	4	88	t	\N	85
184	azumarill	8	189	t	\N	285
185	sudowoodo	12	144	t	\N	380
186	politoed	11	225	t	\N	339
187	hoppip	4	50	t	\N	5
188	skiploom	6	119	t	\N	10
189	jumpluff	8	207	t	\N	30
190	aipom	8	72	t	\N	115
191	sunkern	3	36	t	\N	18
192	sunflora	8	149	t	\N	85
193	yanma	12	78	t	\N	380
194	wooper	4	42	t	\N	85
195	quagsire	14	151	t	\N	750
196	espeon	9	184	t	\N	265
197	umbreon	10	184	t	\N	270
198	murkrow	5	81	t	\N	21
199	slowking	20	172	t	\N	795
200	misdreavus	7	87	t	\N	10
201	unown	5	118	t	\N	50
202	wobbuffet	13	142	t	\N	285
203	girafarig	15	159	t	\N	415
204	pineco	6	58	t	\N	72
205	forretress	12	163	t	\N	1258
206	dunsparce	15	145	t	\N	140
207	gligar	11	86	t	\N	648
208	steelix	92	179	t	\N	4000
209	snubbull	6	60	t	\N	78
210	granbull	14	158	t	\N	487
211	qwilfish	5	88	t	\N	39
212	scizor	18	175	t	\N	1180
213	shuckle	6	177	t	\N	205
214	heracross	15	175	t	\N	540
215	sneasel	9	86	t	\N	280
216	teddiursa	6	66	t	\N	88
217	ursaring	18	175	t	\N	1258
218	slugma	7	50	t	\N	350
219	magcargo	8	151	t	\N	550
220	swinub	4	50	t	\N	65
221	piloswine	11	158	t	\N	558
222	corsola	6	144	t	\N	50
223	remoraid	6	60	t	\N	120
224	octillery	9	168	t	\N	285
225	delibird	9	116	t	\N	160
226	mantine	21	170	t	\N	2200
227	skarmory	17	163	t	\N	505
228	houndour	6	66	t	\N	108
229	houndoom	14	175	t	\N	350
230	kingdra	18	243	t	\N	1520
231	phanpy	5	66	t	\N	335
232	donphan	11	175	t	\N	1200
233	porygon2	6	180	t	\N	325
234	stantler	14	163	t	\N	712
235	smeargle	12	88	t	\N	580
236	tyrogue	7	42	t	\N	210
237	hitmontop	14	159	t	\N	480
238	smoochum	4	61	t	\N	60
239	elekid	6	72	t	\N	235
240	magby	7	73	t	\N	214
241	miltank	12	172	t	\N	755
242	blissey	15	608	t	\N	468
243	raikou	19	261	t	\N	1780
244	entei	21	261	t	\N	1980
245	suicune	20	261	t	\N	1870
246	larvitar	6	60	t	\N	720
247	pupitar	12	144	t	\N	1520
248	tyranitar	20	270	t	\N	2020
249	lugia	52	306	t	\N	2160
250	ho-oh	38	306	t	\N	1990
251	celebi	6	270	t	\N	50
252	treecko	5	62	t	\N	50
253	grovyle	9	142	t	\N	216
254	sceptile	17	239	t	\N	522
255	torchic	4	62	t	\N	25
256	combusken	9	142	t	\N	195
257	blaziken	19	239	t	\N	520
258	mudkip	4	62	t	\N	76
259	marshtomp	7	142	t	\N	280
260	swampert	15	241	t	\N	819
261	poochyena	5	56	t	\N	136
262	mightyena	10	147	t	\N	370
263	zigzagoon	4	56	t	\N	175
264	linoone	5	147	t	\N	325
265	wurmple	3	56	t	\N	36
266	silcoon	6	72	t	\N	100
267	beautifly	10	178	t	\N	284
268	cascoon	7	72	t	\N	115
269	dustox	12	173	t	\N	316
270	lotad	5	44	t	\N	26
271	lombre	12	119	t	\N	325
272	ludicolo	15	216	t	\N	550
273	seedot	5	44	t	\N	40
274	nuzleaf	10	119	t	\N	280
275	shiftry	13	216	t	\N	596
276	taillow	3	54	t	\N	23
277	swellow	7	159	t	\N	198
278	wingull	6	54	t	\N	95
279	pelipper	12	154	t	\N	280
280	ralts	4	40	t	\N	66
281	kirlia	8	97	t	\N	202
282	gardevoir	16	233	t	\N	484
283	surskit	5	54	t	\N	17
284	masquerain	8	159	t	\N	36
285	shroomish	4	59	t	\N	45
286	breloom	12	161	t	\N	392
287	slakoth	8	56	t	\N	240
288	vigoroth	14	154	t	\N	465
289	slaking	20	252	t	\N	1305
290	nincada	5	53	t	\N	55
291	ninjask	8	160	t	\N	120
292	shedinja	8	83	t	\N	12
293	whismur	6	48	t	\N	163
294	loudred	10	126	t	\N	405
295	exploud	15	221	t	\N	840
296	makuhita	10	47	t	\N	864
297	hariyama	23	166	t	\N	2538
298	azurill	2	38	t	\N	20
299	nosepass	10	75	t	\N	970
300	skitty	6	52	t	\N	110
301	delcatty	11	140	t	\N	326
302	sableye	5	133	t	\N	110
303	mawile	6	133	t	\N	115
304	aron	4	66	t	\N	600
305	lairon	9	151	t	\N	1200
306	aggron	21	239	t	\N	3600
307	meditite	6	56	t	\N	112
308	medicham	13	144	t	\N	315
309	electrike	6	59	t	\N	152
310	manectric	15	166	t	\N	402
311	plusle	4	142	t	\N	42
312	minun	4	142	t	\N	42
313	volbeat	7	151	t	\N	177
314	illumise	6	151	t	\N	177
315	roselia	3	140	t	\N	20
316	gulpin	4	60	t	\N	103
317	swalot	17	163	t	\N	800
318	carvanha	8	61	t	\N	208
319	sharpedo	18	161	t	\N	888
320	wailmer	20	80	t	\N	1300
321	wailord	145	175	t	\N	3980
322	numel	7	61	t	\N	240
323	camerupt	19	161	t	\N	2200
324	torkoal	5	165	t	\N	804
325	spoink	7	66	t	\N	306
326	grumpig	9	165	t	\N	715
327	spinda	11	126	t	\N	50
328	trapinch	7	58	t	\N	150
329	vibrava	11	119	t	\N	153
330	flygon	20	234	t	\N	820
331	cacnea	4	67	t	\N	513
332	cacturne	13	166	t	\N	774
333	swablu	4	62	t	\N	12
334	altaria	11	172	t	\N	206
335	zangoose	13	160	t	\N	403
336	seviper	27	160	t	\N	525
337	lunatone	10	161	t	\N	1680
338	solrock	12	161	t	\N	1540
339	barboach	4	58	t	\N	19
340	whiscash	9	164	t	\N	236
341	corphish	6	62	t	\N	115
342	crawdaunt	11	164	t	\N	328
343	baltoy	5	60	t	\N	215
344	claydol	15	175	t	\N	1080
345	lileep	10	71	t	\N	238
346	cradily	15	173	t	\N	604
347	anorith	7	71	t	\N	125
348	armaldo	15	173	t	\N	682
349	feebas	6	40	t	\N	74
350	milotic	62	189	t	\N	1620
351	castform	3	147	t	\N	8
352	kecleon	10	154	t	\N	220
353	shuppet	6	59	t	\N	23
354	banette	11	159	t	\N	125
355	duskull	8	59	t	\N	150
356	dusclops	16	159	t	\N	306
357	tropius	20	161	t	\N	1000
358	chimecho	6	159	t	\N	10
359	absol	12	163	t	\N	470
360	wynaut	6	52	t	\N	140
361	snorunt	7	60	t	\N	168
362	glalie	15	168	t	\N	2565
363	spheal	8	58	t	\N	395
364	sealeo	11	144	t	\N	876
365	walrein	14	239	t	\N	1506
366	clamperl	4	69	t	\N	525
367	huntail	17	170	t	\N	270
368	gorebyss	18	170	t	\N	226
369	relicanth	10	170	t	\N	234
370	luvdisc	6	116	t	\N	87
371	bagon	6	60	t	\N	421
372	shelgon	11	147	t	\N	1105
373	salamence	15	270	t	\N	1026
374	beldum	6	60	t	\N	952
375	metang	12	147	t	\N	2025
376	metagross	16	270	t	\N	5500
377	regirock	17	261	t	\N	2300
378	regice	18	261	t	\N	1750
379	registeel	19	261	t	\N	2050
380	latias	14	270	t	\N	400
381	latios	20	270	t	\N	600
382	kyogre	45	302	t	\N	3520
383	groudon	35	302	t	\N	9500
384	rayquaza	70	306	t	\N	2065
385	jirachi	3	270	t	\N	11
386	deoxys-normal	17	270	t	\N	608
387	turtwig	4	64	t	\N	102
388	grotle	11	142	t	\N	970
389	torterra	22	236	t	\N	3100
390	chimchar	5	62	t	\N	62
391	monferno	9	142	t	\N	220
392	infernape	12	240	t	\N	550
393	piplup	4	63	t	\N	52
394	prinplup	8	142	t	\N	230
395	empoleon	17	239	t	\N	845
396	starly	3	49	t	\N	20
397	staravia	6	119	t	\N	155
398	staraptor	12	218	t	\N	249
399	bidoof	5	50	t	\N	200
400	bibarel	10	144	t	\N	315
401	kricketot	3	39	t	\N	22
402	kricketune	10	134	t	\N	255
403	shinx	5	53	t	\N	95
404	luxio	9	127	t	\N	305
405	luxray	14	235	t	\N	420
406	budew	2	56	t	\N	12
407	roserade	9	232	t	\N	145
408	cranidos	9	70	t	\N	315
409	rampardos	16	173	t	\N	1025
410	shieldon	5	70	t	\N	570
411	bastiodon	13	173	t	\N	1495
412	burmy	2	45	t	\N	34
413	wormadam-plant	5	148	t	\N	65
414	mothim	9	148	t	\N	233
415	combee	3	49	t	\N	55
416	vespiquen	12	166	t	\N	385
417	pachirisu	4	142	t	\N	39
418	buizel	7	66	t	\N	295
419	floatzel	11	173	t	\N	335
420	cherubi	4	55	t	\N	33
421	cherrim	5	158	t	\N	93
422	shellos	3	65	t	\N	63
423	gastrodon	9	166	t	\N	299
424	ambipom	12	169	t	\N	203
425	drifloon	4	70	t	\N	12
426	drifblim	12	174	t	\N	150
427	buneary	4	70	t	\N	55
428	lopunny	12	168	t	\N	333
429	mismagius	9	173	t	\N	44
430	honchkrow	9	177	t	\N	273
431	glameow	5	62	t	\N	39
432	purugly	10	158	t	\N	438
433	chingling	2	57	t	\N	6
434	stunky	4	66	t	\N	192
435	skuntank	10	168	t	\N	380
436	bronzor	5	60	t	\N	605
437	bronzong	13	175	t	\N	1870
438	bonsly	5	58	t	\N	150
439	mime-jr	6	62	t	\N	130
440	happiny	6	110	t	\N	244
441	chatot	5	144	t	\N	19
442	spiritomb	10	170	t	\N	1080
443	gible	7	60	t	\N	205
444	gabite	14	144	t	\N	560
445	garchomp	19	270	t	\N	950
446	munchlax	6	78	t	\N	1050
447	riolu	7	57	t	\N	202
448	lucario	12	184	t	\N	540
449	hippopotas	8	66	t	\N	495
450	hippowdon	20	184	t	\N	3000
451	skorupi	8	66	t	\N	120
452	drapion	13	175	t	\N	615
453	croagunk	7	60	t	\N	230
454	toxicroak	13	172	t	\N	444
455	carnivine	14	159	t	\N	270
456	finneon	4	66	t	\N	70
457	lumineon	12	161	t	\N	240
458	mantyke	10	69	t	\N	650
459	snover	10	67	t	\N	505
460	abomasnow	22	173	t	\N	1355
461	weavile	11	179	t	\N	340
462	magnezone	12	241	t	\N	1800
463	lickilicky	17	180	t	\N	1400
464	rhyperior	24	241	t	\N	2828
465	tangrowth	20	187	t	\N	1286
466	electivire	18	243	t	\N	1386
467	magmortar	16	243	t	\N	680
468	togekiss	15	245	t	\N	380
469	yanmega	19	180	t	\N	515
470	leafeon	10	184	t	\N	255
471	glaceon	8	184	t	\N	259
472	gliscor	20	179	t	\N	425
473	mamoswine	25	239	t	\N	2910
474	porygon-z	9	241	t	\N	340
475	gallade	16	233	t	\N	520
476	probopass	14	184	t	\N	3400
477	dusknoir	22	236	t	\N	1066
478	froslass	13	168	t	\N	266
479	rotom	3	154	t	\N	3
480	uxie	3	261	t	\N	3
481	mesprit	3	261	t	\N	3
482	azelf	3	261	t	\N	3
483	dialga	54	306	t	\N	6830
484	palkia	42	306	t	\N	3360
485	heatran	17	270	t	\N	4300
486	regigigas	37	302	t	\N	4200
487	giratina-altered	45	306	t	\N	7500
488	cresselia	15	270	t	\N	856
489	phione	4	216	t	\N	31
490	manaphy	3	270	t	\N	14
491	darkrai	15	270	t	\N	505
492	shaymin-land	2	270	t	\N	21
493	arceus	32	324	t	\N	3200
494	victini	4	270	t	\N	40
495	snivy	6	62	t	\N	81
496	servine	8	145	t	\N	160
497	serperior	33	238	t	\N	630
498	tepig	5	62	t	\N	99
499	pignite	10	146	t	\N	555
500	emboar	16	238	t	\N	1500
501	oshawott	5	62	t	\N	59
502	dewott	8	145	t	\N	245
503	samurott	15	238	t	\N	946
504	patrat	5	51	t	\N	116
505	watchog	11	147	t	\N	270
506	lillipup	4	55	t	\N	41
507	herdier	9	130	t	\N	147
508	stoutland	12	225	t	\N	610
509	purrloin	4	56	t	\N	101
510	liepard	11	156	t	\N	375
511	pansage	6	63	t	\N	105
512	simisage	11	174	t	\N	305
513	pansear	6	63	t	\N	110
514	simisear	10	174	t	\N	280
515	panpour	6	63	t	\N	135
516	simipour	10	174	t	\N	290
517	munna	6	58	t	\N	233
518	musharna	11	170	t	\N	605
519	pidove	3	53	t	\N	21
520	tranquill	6	125	t	\N	150
521	unfezant	12	220	t	\N	290
522	blitzle	8	59	t	\N	298
523	zebstrika	16	174	t	\N	795
524	roggenrola	4	56	t	\N	180
525	boldore	9	137	t	\N	1020
526	gigalith	17	232	t	\N	2600
527	woobat	4	65	t	\N	21
528	swoobat	9	149	t	\N	105
529	drilbur	3	66	t	\N	85
530	excadrill	7	178	t	\N	404
531	audino	11	390	t	\N	310
532	timburr	6	61	t	\N	125
533	gurdurr	12	142	t	\N	400
534	conkeldurr	14	227	t	\N	870
535	tympole	5	59	t	\N	45
536	palpitoad	8	134	t	\N	170
537	seismitoad	15	229	t	\N	620
538	throh	13	163	t	\N	555
539	sawk	14	163	t	\N	510
540	sewaddle	3	62	t	\N	25
541	swadloon	5	133	t	\N	73
542	leavanny	12	225	t	\N	205
543	venipede	4	52	t	\N	53
544	whirlipede	12	126	t	\N	585
545	scolipede	25	218	t	\N	2005
546	cottonee	3	56	t	\N	6
547	whimsicott	7	168	t	\N	66
548	petilil	5	56	t	\N	66
549	lilligant	11	168	t	\N	163
550	basculin-red-striped	10	161	t	\N	180
551	sandile	7	58	t	\N	152
552	krokorok	10	123	t	\N	334
553	krookodile	15	234	t	\N	963
554	darumaka	6	63	t	\N	375
555	darmanitan-standard	13	168	t	\N	929
556	maractus	10	161	t	\N	280
557	dwebble	3	65	t	\N	145
558	crustle	14	170	t	\N	2000
559	scraggy	6	70	t	\N	118
560	scrafty	11	171	t	\N	300
561	sigilyph	14	172	t	\N	140
562	yamask	5	61	t	\N	15
563	cofagrigus	17	169	t	\N	765
564	tirtouga	7	71	t	\N	165
565	carracosta	12	173	t	\N	810
566	archen	5	71	t	\N	95
567	archeops	14	177	t	\N	320
568	trubbish	6	66	t	\N	310
569	garbodor	19	166	t	\N	1073
570	zorua	7	66	t	\N	125
571	zoroark	16	179	t	\N	811
572	minccino	4	60	t	\N	58
573	cinccino	5	165	t	\N	75
574	gothita	4	58	t	\N	58
575	gothorita	7	137	t	\N	180
576	gothitelle	15	221	t	\N	440
577	solosis	3	58	t	\N	10
578	duosion	6	130	t	\N	80
579	reuniclus	10	221	t	\N	201
580	ducklett	5	61	t	\N	55
581	swanna	13	166	t	\N	242
582	vanillite	4	61	t	\N	57
583	vanillish	11	138	t	\N	410
584	vanilluxe	13	241	t	\N	575
585	deerling	6	67	t	\N	195
586	sawsbuck	19	166	t	\N	925
587	emolga	4	150	t	\N	50
588	karrablast	5	63	t	\N	59
589	escavalier	10	173	t	\N	330
590	foongus	2	59	t	\N	10
591	amoonguss	6	162	t	\N	105
592	frillish	12	67	t	\N	330
593	jellicent	22	168	t	\N	1350
594	alomomola	12	165	t	\N	316
595	joltik	1	64	t	\N	6
596	galvantula	8	165	t	\N	143
597	ferroseed	6	61	t	\N	188
598	ferrothorn	10	171	t	\N	1100
599	klink	3	60	t	\N	210
600	klang	6	154	t	\N	510
601	klinklang	6	234	t	\N	810
602	tynamo	2	55	t	\N	3
603	eelektrik	12	142	t	\N	220
604	eelektross	21	232	t	\N	805
605	elgyem	5	67	t	\N	90
606	beheeyem	10	170	t	\N	345
607	litwick	3	55	t	\N	31
608	lampent	6	130	t	\N	130
609	chandelure	10	234	t	\N	343
610	axew	6	64	t	\N	180
611	fraxure	10	144	t	\N	360
612	haxorus	18	243	t	\N	1055
613	cubchoo	5	61	t	\N	85
614	beartic	26	177	t	\N	2600
615	cryogonal	11	180	t	\N	1480
616	shelmet	4	61	t	\N	77
617	accelgor	8	173	t	\N	253
618	stunfisk	7	165	t	\N	110
619	mienfoo	9	70	t	\N	200
620	mienshao	14	179	t	\N	355
621	druddigon	16	170	t	\N	1390
622	golett	10	61	t	\N	920
623	golurk	28	169	t	\N	3300
624	pawniard	5	68	t	\N	102
625	bisharp	16	172	t	\N	700
626	bouffalant	16	172	t	\N	946
627	rufflet	5	70	t	\N	105
628	braviary	15	179	t	\N	410
629	vullaby	5	74	t	\N	90
630	mandibuzz	12	179	t	\N	395
631	heatmor	14	169	t	\N	580
632	durant	3	169	t	\N	330
633	deino	8	60	t	\N	173
634	zweilous	14	147	t	\N	500
635	hydreigon	18	270	t	\N	1600
636	larvesta	11	72	t	\N	288
637	volcarona	16	248	t	\N	460
638	cobalion	21	261	t	\N	2500
639	terrakion	19	261	t	\N	2600
640	virizion	20	261	t	\N	2000
641	tornadus-incarnate	15	261	t	\N	630
642	thundurus-incarnate	15	261	t	\N	610
643	reshiram	32	306	t	\N	3300
644	zekrom	29	306	t	\N	3450
645	landorus-incarnate	15	270	t	\N	680
646	kyurem	30	297	t	\N	3250
647	keldeo-ordinary	14	261	t	\N	485
648	meloetta-aria	6	270	t	\N	65
649	genesect	15	270	t	\N	825
650	chespin	4	63	t	\N	90
651	quilladin	7	142	t	\N	290
652	chesnaught	16	239	t	\N	900
653	fennekin	4	61	t	\N	94
654	braixen	10	143	t	\N	145
655	delphox	15	240	t	\N	390
656	froakie	3	63	t	\N	70
657	frogadier	6	142	t	\N	109
658	greninja	15	239	t	\N	400
659	bunnelby	4	47	t	\N	50
660	diggersby	10	148	t	\N	424
661	fletchling	3	56	t	\N	17
662	fletchinder	7	134	t	\N	160
663	talonflame	12	175	t	\N	245
664	scatterbug	3	40	t	\N	25
665	spewpa	3	75	t	\N	84
666	vivillon	12	185	t	\N	170
667	litleo	6	74	t	\N	135
668	pyroar	15	177	t	\N	815
669	flabebe	1	61	t	\N	1
670	floette	2	130	t	\N	9
671	florges	11	248	t	\N	100
672	skiddo	9	70	t	\N	310
673	gogoat	17	186	t	\N	910
674	pancham	6	70	t	\N	80
675	pangoro	21	173	t	\N	1360
676	furfrou	12	165	t	\N	280
677	espurr	3	71	t	\N	35
678	meowstic-male	6	163	t	\N	85
679	honedge	8	65	t	\N	20
680	doublade	8	157	t	\N	45
681	aegislash-shield	17	234	t	\N	530
682	spritzee	2	68	t	\N	5
683	aromatisse	8	162	t	\N	155
684	swirlix	4	68	t	\N	35
685	slurpuff	8	168	t	\N	50
686	inkay	4	58	t	\N	35
687	malamar	15	169	t	\N	470
688	binacle	5	61	t	\N	310
689	barbaracle	13	175	t	\N	960
690	skrelp	5	64	t	\N	73
691	dragalge	18	173	t	\N	815
692	clauncher	5	66	t	\N	83
693	clawitzer	13	100	t	\N	353
694	helioptile	5	58	t	\N	60
695	heliolisk	10	168	t	\N	210
696	tyrunt	8	72	t	\N	260
697	tyrantrum	25	182	t	\N	2700
698	amaura	13	72	t	\N	252
699	aurorus	27	104	t	\N	2250
700	sylveon	10	184	t	\N	235
701	hawlucha	8	175	t	\N	215
702	dedenne	2	151	t	\N	22
703	carbink	3	100	t	\N	57
704	goomy	3	60	t	\N	28
705	sliggoo	8	158	t	\N	175
706	goodra	20	270	t	\N	1505
707	klefki	2	165	t	\N	30
708	phantump	4	62	t	\N	70
709	trevenant	15	166	t	\N	710
710	pumpkaboo-average	4	67	t	\N	50
711	gourgeist-average	9	173	t	\N	125
712	bergmite	10	61	t	\N	995
713	avalugg	20	180	t	\N	5050
714	noibat	5	49	t	\N	80
715	noivern	15	187	t	\N	850
716	xerneas	30	306	t	\N	2150
717	yveltal	58	306	t	\N	2030
718	zygarde-50	50	270	t	\N	3050
719	diancie	7	270	t	\N	88
720	hoopa	5	270	t	\N	90
721	volcanion	17	270	t	\N	1950
722	rowlet	3	64	t	\N	15
723	dartrix	7	147	t	\N	160
724	decidueye	16	239	t	\N	366
725	litten	4	64	t	\N	43
726	torracat	7	147	t	\N	250
727	incineroar	18	239	t	\N	830
728	popplio	4	64	t	\N	75
729	brionne	6	147	t	\N	175
730	primarina	18	239	t	\N	440
731	pikipek	3	53	t	\N	12
732	trumbeak	6	124	t	\N	148
733	toucannon	11	218	t	\N	260
734	yungoos	4	51	t	\N	60
735	gumshoos	7	146	t	\N	142
736	grubbin	4	60	t	\N	44
737	charjabug	5	140	t	\N	105
738	vikavolt	15	225	t	\N	450
739	crabrawler	6	68	t	\N	70
740	crabominable	17	167	t	\N	1800
741	oricorio-baile	6	167	t	\N	34
742	cutiefly	1	61	t	\N	2
743	ribombee	2	162	t	\N	5
744	rockruff	5	56	t	\N	92
745	lycanroc-midday	8	170	t	\N	250
746	wishiwashi-solo	2	61	t	\N	3
747	mareanie	4	61	t	\N	80
748	toxapex	7	173	t	\N	145
749	mudbray	10	77	t	\N	1100
750	mudsdale	25	175	t	\N	9200
751	dewpider	3	54	t	\N	40
752	araquanid	18	159	t	\N	820
753	fomantis	3	50	t	\N	15
754	lurantis	9	168	t	\N	185
755	morelull	2	57	t	\N	15
756	shiinotic	10	142	t	\N	115
757	salandit	6	64	t	\N	48
758	salazzle	12	168	t	\N	222
759	stufful	5	68	t	\N	68
760	bewear	21	175	t	\N	1350
761	bounsweet	3	42	t	\N	32
762	steenee	7	102	t	\N	82
763	tsareena	12	230	t	\N	214
764	comfey	1	170	t	\N	3
765	oranguru	15	172	t	\N	760
766	passimian	20	172	t	\N	828
767	wimpod	5	46	t	\N	120
768	golisopod	20	186	t	\N	1080
769	sandygast	5	64	t	\N	700
770	palossand	13	168	t	\N	2500
771	pyukumuku	3	144	t	\N	12
772	type-null	19	107	t	\N	1205
773	silvally	23	257	t	\N	1005
774	minior-red-meteor	3	154	t	\N	400
775	komala	4	168	t	\N	199
776	turtonator	20	170	t	\N	2120
777	togedemaru	3	152	t	\N	33
778	mimikyu-disguised	2	167	t	\N	7
779	bruxish	9	166	t	\N	190
780	drampa	30	170	t	\N	1850
781	dhelmise	39	181	t	\N	2100
782	jangmo-o	6	60	t	\N	297
783	hakamo-o	12	147	t	\N	470
784	kommo-o	16	270	t	\N	782
785	tapu-koko	18	257	t	\N	205
786	tapu-lele	12	257	t	\N	186
787	tapu-bulu	19	257	t	\N	455
788	tapu-fini	13	257	t	\N	212
789	cosmog	2	40	t	\N	1
790	cosmoem	1	140	t	\N	9999
791	solgaleo	34	306	t	\N	2300
792	lunala	40	306	t	\N	1200
793	nihilego	12	257	t	\N	555
794	buzzwole	24	257	t	\N	3336
795	pheromosa	18	257	t	\N	250
796	xurkitree	38	257	t	\N	1000
797	celesteela	92	257	t	\N	9999
798	kartana	3	257	t	\N	1
799	guzzlord	55	257	t	\N	8880
800	necrozma	24	270	t	\N	2300
801	magearna	10	270	t	\N	805
802	marshadow	7	270	t	\N	222
803	poipole	6	189	t	\N	18
804	naganadel	36	243	t	\N	1500
805	stakataka	55	257	t	\N	8200
806	blacephalon	18	257	t	\N	130
807	zeraora	15	270	t	\N	445
808	meltan	2	135	t	\N	80
809	melmetal	25	270	t	\N	8000
810	grookey	3	62	t	\N	50
811	thwackey	7	147	t	\N	140
812	rillaboom	21	265	t	\N	900
813	scorbunny	3	62	t	\N	45
814	raboot	6	147	t	\N	90
815	cinderace	14	265	t	\N	330
816	sobble	3	62	t	\N	40
817	drizzile	7	147	t	\N	115
818	inteleon	19	265	t	\N	452
819	skwovet	3	55	t	\N	25
820	greedent	6	161	t	\N	60
821	rookidee	2	49	t	\N	18
822	corvisquire	8	128	t	\N	160
823	corviknight	22	248	t	\N	750
824	blipbug	4	36	t	\N	80
825	dottler	4	117	t	\N	195
826	orbeetle	4	253	t	\N	408
827	nickit	6	49	t	\N	89
828	thievul	12	159	t	\N	199
829	gossifleur	4	50	t	\N	22
830	eldegoss	5	161	t	\N	25
831	wooloo	6	122	t	\N	60
832	dubwool	13	172	t	\N	430
833	chewtle	3	57	t	\N	85
834	drednaw	10	170	t	\N	1155
835	yamper	3	54	t	\N	135
836	boltund	10	172	t	\N	340
837	rolycoly	3	48	t	\N	120
838	carkol	11	144	t	\N	780
839	coalossal	28	255	t	\N	3105
840	applin	2	52	t	\N	5
841	flapple	3	170	t	\N	10
842	appletun	4	170	t	\N	130
843	silicobra	22	63	t	\N	76
844	sandaconda	38	179	t	\N	655
845	cramorant	8	166	t	\N	180
846	arrokuda	5	56	t	\N	10
847	barraskewda	13	172	t	\N	300
848	toxel	4	48	t	\N	110
849	toxtricity-amped	16	176	t	\N	400
850	sizzlipede	7	61	t	\N	10
851	centiskorch	30	184	t	\N	1200
852	clobbopus	6	62	t	\N	40
853	grapploct	16	168	t	\N	390
854	sinistea	1	62	t	\N	2
855	polteageist	2	178	t	\N	4
856	hatenna	4	53	t	\N	34
857	hattrem	6	130	t	\N	48
858	hatterene	21	255	t	\N	51
859	impidimp	4	53	t	\N	55
860	morgrem	8	130	t	\N	125
861	grimmsnarl	15	255	t	\N	610
862	obstagoon	16	260	t	\N	460
863	perrserker	8	154	t	\N	280
864	cursola	10	179	t	\N	4
865	sirfetchd	8	177	t	\N	1170
866	mr-rime	15	182	t	\N	582
867	runerigus	16	169	t	\N	666
868	milcery	2	54	t	\N	3
869	alcremie	3	173	t	\N	5
870	falinks	30	165	t	\N	620
871	pincurchin	3	152	t	\N	10
872	snom	3	37	t	\N	38
873	frosmoth	13	166	t	\N	420
874	stonjourner	25	165	t	\N	5200
875	eiscue-ice	14	165	t	\N	890
876	indeedee-male	9	166	t	\N	280
877	morpeko-full-belly	3	153	t	\N	30
878	cufant	12	66	t	\N	1000
879	copperajah	30	175	t	\N	6500
880	dracozolt	18	177	t	\N	1900
881	arctozolt	23	177	t	\N	1500
882	dracovish	23	177	t	\N	2150
883	arctovish	20	177	t	\N	1750
884	duraludon	18	187	t	\N	400
885	dreepy	5	54	t	\N	20
886	drakloak	14	144	t	\N	110
887	dragapult	30	300	t	\N	500
888	zacian	28	335	t	\N	1100
889	zamazenta	29	335	t	\N	2100
890	eternatus	200	345	t	\N	9500
891	kubfu	6	77	t	\N	120
892	urshifu-single-strike	19	275	t	\N	1050
893	zarude	18	300	t	\N	700
894	regieleki	12	290	t	\N	1450
895	regidrago	21	290	t	\N	2000
896	glastrier	22	290	t	\N	8000
897	spectrier	20	290	t	\N	445
898	calyrex	11	250	t	\N	77
899	wyrdeer	18	263	t	\N	951
900	kleavor	18	175	t	\N	890
901	ursaluna	24	275	t	\N	2900
902	basculegion-male	30	265	t	\N	1100
903	sneasler	13	102	t	\N	430
904	overqwil	25	179	t	\N	605
905	enamorus-incarnate	16	116	t	\N	480
906	sprigatito	4	62	t	\N	41
907	floragato	9	144	t	\N	122
908	meowscarada	15	265	t	\N	312
909	fuecoco	4	62	t	\N	98
910	crocalor	10	144	t	\N	307
911	skeledirge	16	265	t	\N	3265
912	quaxly	5	62	t	\N	61
913	quaxwell	12	144	t	\N	215
914	quaquaval	18	265	t	\N	619
915	lechonk	5	51	t	\N	102
916	oinkologne-male	10	171	t	\N	1200
917	tarountula	3	42	t	\N	40
918	spidops	10	141	t	\N	165
919	nymble	2	42	t	\N	10
920	lokix	10	158	t	\N	175
921	pawmi	3	48	t	\N	25
922	pawmo	4	123	t	\N	65
923	pawmot	9	245	t	\N	410
924	tandemaus	3	61	t	\N	18
925	maushold-family-of-four	3	165	t	\N	23
926	fidough	3	62	t	\N	109
927	dachsbun	5	167	t	\N	149
928	smoliv	3	52	t	\N	65
929	dolliv	6	124	t	\N	119
930	arboliva	14	255	t	\N	482
931	squawkabilly-green-plumage	6	146	t	\N	24
932	nacli	4	56	t	\N	160
933	naclstack	6	124	t	\N	1050
934	garganacl	23	250	t	\N	2400
935	charcadet	6	51	t	\N	105
936	armarouge	15	263	t	\N	850
937	ceruledge	16	263	t	\N	620
938	tadbulb	3	54	t	\N	4
939	bellibolt	12	173	t	\N	1130
940	wattrel	4	56	t	\N	36
941	kilowattrel	14	172	t	\N	386
942	maschiff	5	68	t	\N	160
943	mabosstiff	11	177	t	\N	610
944	shroodle	2	58	t	\N	7
945	grafaiai	7	170	t	\N	272
946	bramblin	6	55	t	\N	6
947	brambleghast	12	168	t	\N	60
948	toedscool	9	67	t	\N	330
949	toedscruel	19	180	t	\N	580
950	klawf	13	158	t	\N	790
951	capsakid	3	61	t	\N	30
952	scovillain	9	170	t	\N	150
953	rellor	2	54	t	\N	10
954	rabsca	3	165	t	\N	35
955	flittle	2	51	t	\N	15
956	espathra	19	168	t	\N	900
957	tinkatink	4	59	t	\N	89
958	tinkatuff	7	133	t	\N	591
959	tinkaton	7	253	t	\N	1128
960	wiglett	12	49	t	\N	18
961	wugtrio	12	149	t	\N	54
962	bombirdier	15	243	t	\N	429
963	finizen	13	63	t	\N	602
964	palafin-zero	13	160	t	\N	602
965	varoom	10	60	t	\N	350
966	revavroom	18	175	t	\N	1200
967	cyclizar	16	175	t	\N	630
968	orthworm	25	240	t	\N	3100
969	glimmet	7	70	t	\N	80
970	glimmora	15	184	t	\N	450
971	greavard	6	58	t	\N	350
972	houndstone	20	171	t	\N	150
973	flamigo	16	175	t	\N	370
974	cetoddle	12	67	t	\N	450
975	cetitan	45	182	t	\N	7000
976	veluza	25	167	t	\N	900
977	dondozo	120	265	t	\N	2200
978	tatsugiri-curly	3	166	t	\N	80
979	annihilape	12	268	t	\N	560
980	clodsire	18	151	t	\N	2230
981	farigiraf	32	260	t	\N	1600
982	dudunsparce-two-segment	36	182	t	\N	392
983	kingambit	20	275	t	\N	1200
984	great-tusk	22	285	t	\N	3200
985	scream-tail	12	285	t	\N	80
986	brute-bonnet	12	285	t	\N	210
987	flutter-mane	14	285	t	\N	40
988	slither-wing	32	285	t	\N	920
989	sandy-shocks	23	285	t	\N	600
990	iron-treads	9	285	t	\N	2400
991	iron-bundle	6	285	t	\N	110
992	iron-hands	18	285	t	\N	3807
993	iron-jugulis	13	285	t	\N	1110
994	iron-moth	12	285	t	\N	360
995	iron-thorns	16	285	t	\N	3030
996	frigibax	5	64	t	\N	170
997	arctibax	8	148	t	\N	300
998	baxcalibur	21	300	t	\N	2100
999	gimmighoul	3	60	t	\N	50
1000	gholdengo	12	275	t	\N	300
1001	wo-chien	15	285	t	\N	742
1002	chien-pao	19	285	t	\N	1522
1003	ting-lu	27	285	t	\N	6997
1004	chi-yu	4	285	t	\N	49
1005	roaring-moon	20	295	t	\N	3800
1006	iron-valiant	14	295	t	\N	350
1007	koraidon	25	335	t	\N	3030
1008	miraidon	35	335	t	\N	2400
1009	walking-wake	35	295	t	\N	2800
1010	iron-leaves	15	295	t	\N	1250
1011	dipplin	4	170	t	\N	97
1012	poltchageist	1	62	t	\N	11
1013	sinistcha	2	178	t	\N	22
1014	okidogi	18	278	t	\N	922
1015	munkidori	10	278	t	\N	122
1016	fezandipiti	14	278	t	\N	301
1017	ogerpon	12	275	t	\N	398
1018	archaludon	20	300	t	\N	600
1019	hydrapple	18	270	t	\N	930
1020	gouging-fire	35	295	t	\N	5900
1021	raging-bolt	52	295	t	\N	4800
1022	iron-boulder	15	295	t	\N	1625
1023	iron-crown	16	295	t	\N	1560
1024	terapagos	2	90	t	\N	65
1025	pecharunt	3	300	t	\N	3
\.


--
-- Data for Name: pokemon_sprites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pokemon_sprites (pokemon_id, front_default, front_shiny, back_default, back_shiny, official_artwork) FROM stdin;
\.


--
-- Data for Name: pokemon_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pokemon_stats (pokemon_id, stat_name, base_stat, effort) FROM stdin;
\.


--
-- Data for Name: pokemon_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pokemon_types (id, pokemon_id, type_name, slot) FROM stdin;
1	\N	grass	1
2	\N	grass	1
3	\N	grass	1
4	\N	fire	1
5	\N	fire	1
6	\N	fire	1
7	\N	water	1
8	\N	water	1
9	\N	water	1
10	\N	bug	1
11	\N	bug	1
12	\N	bug	1
13	\N	bug	1
14	\N	bug	1
15	\N	bug	1
16	\N	normal	1
17	\N	normal	1
18	\N	normal	1
19	\N	normal	1
20	\N	normal	1
21	\N	normal	1
22	\N	normal	1
23	\N	poison	1
24	\N	poison	1
25	\N	electric	1
26	\N	electric	1
27	\N	ground	1
28	\N	ground	1
29	\N	poison	1
30	\N	poison	1
31	\N	poison	1
32	\N	poison	1
33	\N	poison	1
34	\N	poison	1
35	\N	fairy	1
36	\N	fairy	1
37	\N	fire	1
38	\N	fire	1
39	\N	normal	1
40	\N	normal	1
41	\N	poison	1
42	\N	poison	1
43	\N	grass	1
44	\N	grass	1
45	\N	grass	1
46	\N	bug	1
47	\N	bug	1
48	\N	bug	1
49	\N	bug	1
50	\N	ground	1
51	\N	ground	1
52	\N	normal	1
53	\N	normal	1
54	\N	water	1
55	\N	water	1
56	\N	fighting	1
57	\N	fighting	1
58	\N	fire	1
59	\N	fire	1
60	\N	water	1
61	\N	water	1
62	\N	water	1
63	\N	psychic	1
64	\N	psychic	1
65	\N	psychic	1
66	\N	fighting	1
67	\N	fighting	1
68	\N	fighting	1
69	\N	grass	1
70	\N	grass	1
71	\N	grass	1
72	\N	water	1
73	\N	water	1
74	\N	rock	1
75	\N	rock	1
76	\N	rock	1
77	\N	fire	1
78	\N	fire	1
79	\N	water	1
80	\N	water	1
81	\N	electric	1
82	\N	electric	1
83	\N	normal	1
84	\N	normal	1
85	\N	normal	1
86	\N	water	1
87	\N	water	1
88	\N	poison	1
89	\N	poison	1
90	\N	water	1
91	\N	water	1
92	\N	ghost	1
93	\N	ghost	1
94	\N	ghost	1
95	\N	rock	1
96	\N	psychic	1
97	\N	psychic	1
98	\N	water	1
99	\N	water	1
100	\N	electric	1
101	\N	electric	1
102	\N	grass	1
103	\N	grass	1
104	\N	ground	1
105	\N	ground	1
106	\N	fighting	1
107	\N	fighting	1
108	\N	normal	1
109	\N	poison	1
110	\N	poison	1
111	\N	ground	1
112	\N	ground	1
113	\N	normal	1
114	\N	grass	1
115	\N	normal	1
116	\N	water	1
117	\N	water	1
118	\N	water	1
119	\N	water	1
120	\N	water	1
121	\N	water	1
122	\N	psychic	1
123	\N	bug	1
124	\N	ice	1
125	\N	electric	1
126	\N	fire	1
127	\N	bug	1
128	\N	normal	1
129	\N	water	1
130	\N	water	1
131	\N	water	1
132	\N	normal	1
133	\N	normal	1
134	\N	water	1
135	\N	electric	1
136	\N	fire	1
137	\N	normal	1
138	\N	rock	1
139	\N	rock	1
140	\N	rock	1
141	\N	rock	1
142	\N	rock	1
143	\N	normal	1
144	\N	ice	1
145	\N	electric	1
146	\N	fire	1
147	\N	dragon	1
148	\N	dragon	1
149	\N	dragon	1
150	\N	psychic	1
151	\N	psychic	1
152	\N	grass	1
153	\N	grass	1
154	\N	grass	1
155	\N	fire	1
156	\N	fire	1
157	\N	fire	1
158	\N	water	1
159	\N	water	1
160	\N	water	1
161	\N	normal	1
162	\N	normal	1
163	\N	normal	1
164	\N	normal	1
165	\N	bug	1
166	\N	bug	1
167	\N	bug	1
168	\N	bug	1
169	\N	poison	1
170	\N	water	1
171	\N	water	1
172	\N	electric	1
173	\N	fairy	1
174	\N	normal	1
175	\N	fairy	1
176	\N	fairy	1
177	\N	psychic	1
178	\N	psychic	1
179	\N	electric	1
180	\N	electric	1
181	\N	electric	1
182	\N	grass	1
183	\N	water	1
184	\N	water	1
185	\N	rock	1
186	\N	water	1
187	\N	grass	1
188	\N	grass	1
189	\N	grass	1
190	\N	normal	1
191	\N	grass	1
192	\N	grass	1
193	\N	bug	1
194	\N	water	1
195	\N	water	1
196	\N	psychic	1
197	\N	dark	1
198	\N	dark	1
199	\N	water	1
200	\N	ghost	1
201	\N	psychic	1
202	\N	psychic	1
203	\N	normal	1
204	\N	bug	1
205	\N	bug	1
206	\N	normal	1
207	\N	ground	1
208	\N	steel	1
209	\N	fairy	1
210	\N	fairy	1
211	\N	water	1
212	\N	bug	1
213	\N	bug	1
214	\N	bug	1
215	\N	dark	1
216	\N	normal	1
217	\N	normal	1
218	\N	fire	1
219	\N	fire	1
220	\N	ice	1
221	\N	ice	1
222	\N	water	1
223	\N	water	1
224	\N	water	1
225	\N	ice	1
226	\N	water	1
227	\N	steel	1
228	\N	dark	1
229	\N	dark	1
230	\N	water	1
231	\N	ground	1
232	\N	ground	1
233	\N	normal	1
234	\N	normal	1
235	\N	normal	1
236	\N	fighting	1
237	\N	fighting	1
238	\N	ice	1
239	\N	electric	1
240	\N	fire	1
241	\N	normal	1
242	\N	normal	1
243	\N	electric	1
244	\N	fire	1
245	\N	water	1
246	\N	rock	1
247	\N	rock	1
248	\N	rock	1
249	\N	psychic	1
250	\N	fire	1
251	\N	psychic	1
252	\N	grass	1
253	\N	grass	1
254	\N	grass	1
255	\N	fire	1
256	\N	fire	1
257	\N	fire	1
258	\N	water	1
259	\N	water	1
260	\N	water	1
261	\N	dark	1
262	\N	dark	1
263	\N	normal	1
264	\N	normal	1
265	\N	bug	1
266	\N	bug	1
267	\N	bug	1
268	\N	bug	1
269	\N	bug	1
270	\N	water	1
271	\N	water	1
272	\N	water	1
273	\N	grass	1
274	\N	grass	1
275	\N	grass	1
276	\N	normal	1
277	\N	normal	1
278	\N	water	1
279	\N	water	1
280	\N	psychic	1
281	\N	psychic	1
282	\N	psychic	1
283	\N	bug	1
284	\N	bug	1
285	\N	grass	1
286	\N	grass	1
287	\N	normal	1
288	\N	normal	1
289	\N	normal	1
290	\N	bug	1
291	\N	bug	1
292	\N	bug	1
293	\N	normal	1
294	\N	normal	1
295	\N	normal	1
296	\N	fighting	1
297	\N	fighting	1
298	\N	normal	1
299	\N	rock	1
300	\N	normal	1
301	\N	normal	1
302	\N	dark	1
303	\N	steel	1
304	\N	steel	1
305	\N	steel	1
306	\N	steel	1
307	\N	fighting	1
308	\N	fighting	1
309	\N	electric	1
310	\N	electric	1
311	\N	electric	1
312	\N	electric	1
313	\N	bug	1
314	\N	bug	1
315	\N	grass	1
316	\N	poison	1
317	\N	poison	1
318	\N	water	1
319	\N	water	1
320	\N	water	1
321	\N	water	1
322	\N	fire	1
323	\N	fire	1
324	\N	fire	1
325	\N	psychic	1
326	\N	psychic	1
327	\N	normal	1
328	\N	ground	1
329	\N	ground	1
330	\N	ground	1
331	\N	grass	1
332	\N	grass	1
333	\N	normal	1
334	\N	dragon	1
335	\N	normal	1
336	\N	poison	1
337	\N	rock	1
338	\N	rock	1
339	\N	water	1
340	\N	water	1
341	\N	water	1
342	\N	water	1
343	\N	ground	1
344	\N	ground	1
345	\N	rock	1
346	\N	rock	1
347	\N	rock	1
348	\N	rock	1
349	\N	water	1
350	\N	water	1
351	\N	normal	1
352	\N	normal	1
353	\N	ghost	1
354	\N	ghost	1
355	\N	ghost	1
356	\N	ghost	1
357	\N	grass	1
358	\N	psychic	1
359	\N	dark	1
360	\N	psychic	1
361	\N	ice	1
362	\N	ice	1
363	\N	ice	1
364	\N	ice	1
365	\N	ice	1
366	\N	water	1
367	\N	water	1
368	\N	water	1
369	\N	water	1
370	\N	water	1
371	\N	dragon	1
372	\N	dragon	1
373	\N	dragon	1
374	\N	steel	1
375	\N	steel	1
376	\N	steel	1
377	\N	rock	1
378	\N	ice	1
379	\N	steel	1
380	\N	dragon	1
381	\N	dragon	1
382	\N	water	1
383	\N	ground	1
384	\N	dragon	1
385	\N	steel	1
386	\N	psychic	1
387	\N	grass	1
388	\N	grass	1
389	\N	grass	1
390	\N	fire	1
391	\N	fire	1
392	\N	fire	1
393	\N	water	1
394	\N	water	1
395	\N	water	1
396	\N	normal	1
397	\N	normal	1
398	\N	normal	1
399	\N	normal	1
400	\N	normal	1
401	\N	bug	1
402	\N	bug	1
403	\N	electric	1
404	\N	electric	1
405	\N	electric	1
406	\N	grass	1
407	\N	grass	1
408	\N	rock	1
409	\N	rock	1
410	\N	rock	1
411	\N	rock	1
412	\N	bug	1
413	\N	bug	1
414	\N	bug	1
415	\N	bug	1
416	\N	bug	1
417	\N	electric	1
418	\N	water	1
419	\N	water	1
420	\N	grass	1
421	\N	grass	1
422	\N	water	1
423	\N	water	1
424	\N	normal	1
425	\N	ghost	1
426	\N	ghost	1
427	\N	normal	1
428	\N	normal	1
429	\N	ghost	1
430	\N	dark	1
431	\N	normal	1
432	\N	normal	1
433	\N	psychic	1
434	\N	poison	1
435	\N	poison	1
436	\N	steel	1
437	\N	steel	1
438	\N	rock	1
439	\N	psychic	1
440	\N	normal	1
441	\N	normal	1
442	\N	ghost	1
443	\N	dragon	1
444	\N	dragon	1
445	\N	dragon	1
446	\N	normal	1
447	\N	fighting	1
448	\N	fighting	1
449	\N	ground	1
450	\N	ground	1
451	\N	poison	1
452	\N	poison	1
453	\N	poison	1
454	\N	poison	1
455	\N	grass	1
456	\N	water	1
457	\N	water	1
458	\N	water	1
459	\N	grass	1
460	\N	grass	1
461	\N	dark	1
462	\N	electric	1
463	\N	normal	1
464	\N	ground	1
465	\N	grass	1
466	\N	electric	1
467	\N	fire	1
468	\N	fairy	1
469	\N	bug	1
470	\N	grass	1
471	\N	ice	1
472	\N	ground	1
473	\N	ice	1
474	\N	normal	1
475	\N	psychic	1
476	\N	rock	1
477	\N	ghost	1
478	\N	ice	1
479	\N	electric	1
480	\N	psychic	1
481	\N	psychic	1
482	\N	psychic	1
483	\N	steel	1
484	\N	water	1
485	\N	fire	1
486	\N	normal	1
487	\N	ghost	1
488	\N	psychic	1
489	\N	water	1
490	\N	water	1
491	\N	dark	1
492	\N	grass	1
493	\N	normal	1
494	\N	psychic	1
495	\N	grass	1
496	\N	grass	1
497	\N	grass	1
498	\N	fire	1
499	\N	fire	1
500	\N	fire	1
501	\N	water	1
502	\N	water	1
503	\N	water	1
504	\N	normal	1
505	\N	normal	1
506	\N	normal	1
507	\N	normal	1
508	\N	normal	1
509	\N	dark	1
510	\N	dark	1
511	\N	grass	1
512	\N	grass	1
513	\N	fire	1
514	\N	fire	1
515	\N	water	1
516	\N	water	1
517	\N	psychic	1
518	\N	psychic	1
519	\N	normal	1
520	\N	normal	1
521	\N	normal	1
522	\N	electric	1
523	\N	electric	1
524	\N	rock	1
525	\N	rock	1
526	\N	rock	1
527	\N	psychic	1
528	\N	psychic	1
529	\N	ground	1
530	\N	ground	1
531	\N	normal	1
532	\N	fighting	1
533	\N	fighting	1
534	\N	fighting	1
535	\N	water	1
536	\N	water	1
537	\N	water	1
538	\N	fighting	1
539	\N	fighting	1
540	\N	bug	1
541	\N	bug	1
542	\N	bug	1
543	\N	bug	1
544	\N	bug	1
545	\N	bug	1
546	\N	grass	1
547	\N	grass	1
548	\N	grass	1
549	\N	grass	1
550	\N	water	1
551	\N	ground	1
552	\N	ground	1
553	\N	ground	1
554	\N	fire	1
555	\N	fire	1
556	\N	grass	1
557	\N	bug	1
558	\N	bug	1
559	\N	dark	1
560	\N	dark	1
561	\N	psychic	1
562	\N	ghost	1
563	\N	ghost	1
564	\N	water	1
565	\N	water	1
566	\N	rock	1
567	\N	rock	1
568	\N	poison	1
569	\N	poison	1
570	\N	dark	1
571	\N	dark	1
572	\N	normal	1
573	\N	normal	1
574	\N	psychic	1
575	\N	psychic	1
576	\N	psychic	1
577	\N	psychic	1
578	\N	psychic	1
579	\N	psychic	1
580	\N	water	1
581	\N	water	1
582	\N	ice	1
583	\N	ice	1
584	\N	ice	1
585	\N	normal	1
586	\N	normal	1
587	\N	electric	1
588	\N	bug	1
589	\N	bug	1
590	\N	grass	1
591	\N	grass	1
592	\N	water	1
593	\N	water	1
594	\N	water	1
595	\N	bug	1
596	\N	bug	1
597	\N	grass	1
598	\N	grass	1
599	\N	steel	1
600	\N	steel	1
601	\N	steel	1
602	\N	electric	1
603	\N	electric	1
604	\N	electric	1
605	\N	psychic	1
606	\N	psychic	1
607	\N	ghost	1
608	\N	ghost	1
609	\N	ghost	1
610	\N	dragon	1
611	\N	dragon	1
612	\N	dragon	1
613	\N	ice	1
614	\N	ice	1
615	\N	ice	1
616	\N	bug	1
617	\N	bug	1
618	\N	ground	1
619	\N	fighting	1
620	\N	fighting	1
621	\N	dragon	1
622	\N	ground	1
623	\N	ground	1
624	\N	dark	1
625	\N	dark	1
626	\N	normal	1
627	\N	normal	1
628	\N	normal	1
629	\N	dark	1
630	\N	dark	1
631	\N	fire	1
632	\N	bug	1
633	\N	dark	1
634	\N	dark	1
635	\N	dark	1
636	\N	bug	1
637	\N	bug	1
638	\N	steel	1
639	\N	rock	1
640	\N	grass	1
641	\N	flying	1
642	\N	electric	1
643	\N	dragon	1
644	\N	dragon	1
645	\N	ground	1
646	\N	dragon	1
647	\N	water	1
648	\N	normal	1
649	\N	bug	1
650	\N	grass	1
651	\N	grass	1
652	\N	grass	1
653	\N	fire	1
654	\N	fire	1
655	\N	fire	1
656	\N	water	1
657	\N	water	1
658	\N	water	1
659	\N	normal	1
660	\N	normal	1
661	\N	normal	1
662	\N	fire	1
663	\N	fire	1
664	\N	bug	1
665	\N	bug	1
666	\N	bug	1
667	\N	fire	1
668	\N	fire	1
669	\N	fairy	1
670	\N	fairy	1
671	\N	fairy	1
672	\N	grass	1
673	\N	grass	1
674	\N	fighting	1
675	\N	fighting	1
676	\N	normal	1
677	\N	psychic	1
678	\N	psychic	1
679	\N	steel	1
680	\N	steel	1
681	\N	steel	1
682	\N	fairy	1
683	\N	fairy	1
684	\N	fairy	1
685	\N	fairy	1
686	\N	dark	1
687	\N	dark	1
688	\N	rock	1
689	\N	rock	1
690	\N	poison	1
691	\N	poison	1
692	\N	water	1
693	\N	water	1
694	\N	electric	1
695	\N	electric	1
696	\N	rock	1
697	\N	rock	1
698	\N	rock	1
699	\N	rock	1
700	\N	fairy	1
701	\N	fighting	1
702	\N	electric	1
703	\N	rock	1
704	\N	dragon	1
705	\N	dragon	1
706	\N	dragon	1
707	\N	steel	1
708	\N	ghost	1
709	\N	ghost	1
710	\N	ghost	1
711	\N	ghost	1
712	\N	ice	1
713	\N	ice	1
714	\N	flying	1
715	\N	flying	1
716	\N	fairy	1
717	\N	dark	1
718	\N	dragon	1
719	\N	rock	1
720	\N	psychic	1
721	\N	fire	1
722	\N	grass	1
723	\N	grass	1
724	\N	grass	1
725	\N	fire	1
726	\N	fire	1
727	\N	fire	1
728	\N	water	1
729	\N	water	1
730	\N	water	1
731	\N	normal	1
732	\N	normal	1
733	\N	normal	1
734	\N	normal	1
735	\N	normal	1
736	\N	bug	1
737	\N	bug	1
738	\N	bug	1
739	\N	fighting	1
740	\N	fighting	1
741	\N	fire	1
742	\N	bug	1
743	\N	bug	1
744	\N	rock	1
745	\N	rock	1
746	\N	water	1
747	\N	poison	1
748	\N	poison	1
749	\N	ground	1
750	\N	ground	1
751	\N	water	1
752	\N	water	1
753	\N	grass	1
754	\N	grass	1
755	\N	grass	1
756	\N	grass	1
757	\N	poison	1
758	\N	poison	1
759	\N	normal	1
760	\N	normal	1
761	\N	grass	1
762	\N	grass	1
763	\N	grass	1
764	\N	fairy	1
765	\N	normal	1
766	\N	fighting	1
767	\N	bug	1
768	\N	bug	1
769	\N	ghost	1
770	\N	ghost	1
771	\N	water	1
772	\N	normal	1
773	\N	normal	1
774	\N	rock	1
775	\N	normal	1
776	\N	fire	1
777	\N	electric	1
778	\N	ghost	1
779	\N	water	1
780	\N	normal	1
781	\N	ghost	1
782	\N	dragon	1
783	\N	dragon	1
784	\N	dragon	1
785	\N	electric	1
786	\N	psychic	1
787	\N	grass	1
788	\N	water	1
789	\N	psychic	1
790	\N	psychic	1
791	\N	psychic	1
792	\N	psychic	1
793	\N	rock	1
794	\N	bug	1
795	\N	bug	1
796	\N	electric	1
797	\N	steel	1
798	\N	grass	1
799	\N	dark	1
800	\N	psychic	1
801	\N	steel	1
802	\N	fighting	1
803	\N	poison	1
804	\N	poison	1
805	\N	rock	1
806	\N	fire	1
807	\N	electric	1
808	\N	steel	1
809	\N	steel	1
810	\N	grass	1
811	\N	grass	1
812	\N	grass	1
813	\N	fire	1
814	\N	fire	1
815	\N	fire	1
816	\N	water	1
817	\N	water	1
818	\N	water	1
819	\N	normal	1
820	\N	normal	1
821	\N	flying	1
822	\N	flying	1
823	\N	flying	1
824	\N	bug	1
825	\N	bug	1
826	\N	bug	1
827	\N	dark	1
828	\N	dark	1
829	\N	grass	1
830	\N	grass	1
831	\N	normal	1
832	\N	normal	1
833	\N	water	1
834	\N	water	1
835	\N	electric	1
836	\N	electric	1
837	\N	rock	1
838	\N	rock	1
839	\N	rock	1
840	\N	grass	1
841	\N	grass	1
842	\N	grass	1
843	\N	ground	1
844	\N	ground	1
845	\N	flying	1
846	\N	water	1
847	\N	water	1
848	\N	electric	1
849	\N	electric	1
850	\N	fire	1
851	\N	fire	1
852	\N	fighting	1
853	\N	fighting	1
854	\N	ghost	1
855	\N	ghost	1
856	\N	psychic	1
857	\N	psychic	1
858	\N	psychic	1
859	\N	dark	1
860	\N	dark	1
861	\N	dark	1
862	\N	dark	1
863	\N	steel	1
864	\N	ghost	1
865	\N	fighting	1
866	\N	ice	1
867	\N	ground	1
868	\N	fairy	1
869	\N	fairy	1
870	\N	fighting	1
871	\N	electric	1
872	\N	ice	1
873	\N	ice	1
874	\N	rock	1
875	\N	ice	1
876	\N	psychic	1
877	\N	electric	1
878	\N	steel	1
879	\N	steel	1
880	\N	electric	1
881	\N	electric	1
882	\N	water	1
883	\N	water	1
884	\N	steel	1
885	\N	dragon	1
886	\N	dragon	1
887	\N	dragon	1
888	\N	fairy	1
889	\N	fighting	1
890	\N	poison	1
891	\N	fighting	1
892	\N	fighting	1
893	\N	dark	1
894	\N	electric	1
895	\N	dragon	1
896	\N	ice	1
897	\N	ghost	1
898	\N	psychic	1
899	\N	normal	1
900	\N	bug	1
901	\N	ground	1
902	\N	water	1
903	\N	fighting	1
904	\N	dark	1
905	\N	fairy	1
906	\N	grass	1
907	\N	grass	1
908	\N	grass	1
909	\N	fire	1
910	\N	fire	1
911	\N	fire	1
912	\N	water	1
913	\N	water	1
914	\N	water	1
915	\N	normal	1
916	\N	normal	1
917	\N	bug	1
918	\N	bug	1
919	\N	bug	1
920	\N	bug	1
921	\N	electric	1
922	\N	electric	1
923	\N	electric	1
924	\N	normal	1
925	\N	normal	1
926	\N	fairy	1
927	\N	fairy	1
928	\N	grass	1
929	\N	grass	1
930	\N	grass	1
931	\N	normal	1
932	\N	rock	1
933	\N	rock	1
934	\N	rock	1
935	\N	fire	1
936	\N	fire	1
937	\N	fire	1
938	\N	electric	1
939	\N	electric	1
940	\N	electric	1
941	\N	electric	1
942	\N	dark	1
943	\N	dark	1
944	\N	poison	1
945	\N	poison	1
946	\N	grass	1
947	\N	grass	1
948	\N	ground	1
949	\N	ground	1
950	\N	rock	1
951	\N	grass	1
952	\N	grass	1
953	\N	bug	1
954	\N	bug	1
955	\N	psychic	1
956	\N	psychic	1
957	\N	fairy	1
958	\N	fairy	1
959	\N	fairy	1
960	\N	water	1
961	\N	water	1
962	\N	flying	1
963	\N	water	1
964	\N	water	1
965	\N	steel	1
966	\N	steel	1
967	\N	dragon	1
968	\N	steel	1
969	\N	rock	1
970	\N	rock	1
971	\N	ghost	1
972	\N	ghost	1
973	\N	flying	1
974	\N	ice	1
975	\N	ice	1
976	\N	water	1
977	\N	water	1
978	\N	dragon	1
979	\N	fighting	1
980	\N	poison	1
981	\N	normal	1
982	\N	normal	1
983	\N	dark	1
984	\N	ground	1
985	\N	fairy	1
986	\N	grass	1
987	\N	ghost	1
988	\N	bug	1
989	\N	electric	1
990	\N	ground	1
991	\N	ice	1
992	\N	fighting	1
993	\N	dark	1
994	\N	fire	1
995	\N	rock	1
996	\N	dragon	1
997	\N	dragon	1
998	\N	dragon	1
999	\N	ghost	1
1000	\N	steel	1
1001	\N	dark	1
1002	\N	dark	1
1003	\N	dark	1
1004	\N	dark	1
1005	\N	dragon	1
1006	\N	fairy	1
1007	\N	fighting	1
1008	\N	electric	1
1009	\N	water	1
1010	\N	grass	1
1011	\N	grass	1
1012	\N	grass	1
1013	\N	grass	1
1014	\N	poison	1
1015	\N	poison	1
1016	\N	poison	1
1017	\N	grass	1
1018	\N	steel	1
1019	\N	grass	1
1020	\N	fire	1
1021	\N	electric	1
1022	\N	rock	1
1023	\N	steel	1
1024	\N	normal	1
1025	\N	poison	1
\.


--
-- Data for Name: pokemons_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pokemons_list (id, name, api_url) FROM stdin;
\.


--
-- Name: pokemon_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pokemon_types_id_seq', 100, true);


--
-- Name: pokemons_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pokemons_list_id_seq', 1, false);


--
-- Name: pokemon_details pokemon_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon_details
    ADD CONSTRAINT pokemon_details_pkey PRIMARY KEY (id);


--
-- Name: pokemon_sprites pokemon_sprites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon_sprites
    ADD CONSTRAINT pokemon_sprites_pkey PRIMARY KEY (pokemon_id);


--
-- Name: pokemon_types pokemon_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon_types
    ADD CONSTRAINT pokemon_types_pkey PRIMARY KEY (id);


--
-- Name: pokemons_list pokemons_list_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemons_list
    ADD CONSTRAINT pokemons_list_name_key UNIQUE (name);


--
-- Name: pokemons_list pokemons_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemons_list
    ADD CONSTRAINT pokemons_list_pkey PRIMARY KEY (id);


--
-- Name: pokemon_sprites pokemon_sprites_pokemon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon_sprites
    ADD CONSTRAINT pokemon_sprites_pokemon_id_fkey FOREIGN KEY (pokemon_id) REFERENCES public.pokemons_list(id);


--
-- Name: pokemon_stats pokemon_stats_pokemon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon_stats
    ADD CONSTRAINT pokemon_stats_pokemon_id_fkey FOREIGN KEY (pokemon_id) REFERENCES public.pokemons_list(id);


--
-- Name: pokemon_types pokemon_types_pokemon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon_types
    ADD CONSTRAINT pokemon_types_pokemon_id_fkey FOREIGN KEY (pokemon_id) REFERENCES public.pokemons_list(id);


--
-- PostgreSQL database dump complete
--

\unrestrict czTSE2BIYFGoHJ4Q4WSQB1Ad2HoFhBAjdU8o8IIIoOT9L9VkgGVwaj5VmylAAWq


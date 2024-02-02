create table Users(
  user_id integer generated always as identity  PRIMARY KEY unique not null,
  first_name varchar(255),
  last_name varchar(252),
  address_id varchar(255),
  phone_number varchar(255),
	unique(phone_number),
  password varchar(255),
  email varchar(255) 
);
create table Flights(
  flight_id integer generated always as identity  PRIMARY KEY unique not NULL,
  destination text,
	origin text,
  departure_day timestamp,
  arrival_day timestamp,
	airport_id integer,
  foreign key(airport_id) references Airports(airport_id),
	aircraft_id integer,
	  foreign key(aircraft_id) references Aircrafts(aircraft_id),
	airline_id integer,
  foreign key(airline_id) references Airlines(airline_id)	
);
create table Bookings(
  booking_id integer generated always as identity  PRIMARY KEY unique not NULL,
  flight_id integer, 
  booking_datetime timestamp without time zone,
  foreign key(flight_id) references Flights(flight_id),
  seat_num integer not NULL
);
create table Payment(
  payment_id integer generated always as identity  PRIMARY KEY unique not NULL,
  user_id integer,
  booking_id integer,
  payment_date timestamp without time zone,
  price varchar(255),
  foreign key(booking_id) references bookings(booking_id),
  foreign key(user_id) references Users(user_id)
);
create table Feedback(
  id integer generated always as identity  PRIMARY KEY unique not NULL,
  user_id integer ,
  flight_id integer ,
  rating integer,
  unique(user_id,flight_id),
  foreign key(user_id) references Users(user_id),
  foreign key(flight_id) references Flights(flight_id)  

);
create table Baggage(
  baggage_id integer generated always as identity  PRIMARY KEY unique not null,
  weight varchar(255),
  user_id integer ,
  foreign key(user_id) references Users(user_id)

);
create table Airlines(
  airline_id integer generated always as identity  PRIMARY KEY unique not null,
  aircraft_id integer,
        name varchar(255),
  foreign key(aircraft_id) references Aircrafts(aircraft_id),
	unique(airline_id,aircraft_id)
);
create table Airports(
  airport_id integer generated always as identity  PRIMARY KEY unique not null,
  name varchar(255),
  city varchar(255),
  country varchar(255),
  airline_id integer,
  foreign key(airline_id) references Airlines(airline_id)
);

create table Aircrafts(
  aircraft_id integer generated always as identity  PRIMARY KEY unique not null,
  model varchar(255)
);

create table Crew(
  crew_id integer generated always as identity  PRIMARY KEY unique not null,
  airport_id integer ,
  foreign key(airport_id) references Airports(airport_id),
  first_name varchar(255),
  last_name varchar(255),
  gender text check(gender='Male' or gender='Female'),
  position text
);
create table Review(
   result_exam integer,
  crew_id integer,
  aircraft_id integer,
  primary key(crew_id,aircraft_id),
  foreign key(crew_id) references Crew(crew_id),
  foreign key(aircraft_id) references Aircrafts(aircraft_id)    
);
create table Maintnance(
  last_repair timestamp,
  aircraft_id integer,
  airline_id integer,
  primary key(aircraft_id,airline_id),
  foreign key(aircraft_id) references Aircrafts(aircraft_id),
  foreign key(airline_id) references Airlines(airline_id)
);

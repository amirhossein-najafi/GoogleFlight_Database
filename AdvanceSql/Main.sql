//view

//View for domestic flights for each airline.

create view domestic as
select * from flights
where destination=origin 
group by airline_id,flight_id

-- SELECT * FROM domestic;

--View for flights that has specific destination.

create view same_flights as
select * from flights
where destination='Ukraine'
group by flight_id

-- SELECT * FROM same_flights;


//materilized view

//Create a materialized view that show all aircrafts of each airline
create materialized view aircraftview as
select aircrafts.* , airline_id from aircrafts
join airlines using (aircraft_id)
group by airline_id , aircraft_id

-- SELECT * FROM aircraftview;


--materialized View that show all airline of each airports

create materialized view airlineview as
select airlines.airline_id , airport_id from airlines
join airports using (airline_id)
group by airport_id,airlines.airline_id

-- select * from airlineview

//function


// Write a function that returns the list of trips by getting a user's ID

Create function trips(u_id int)  
returns table ( flight_id int ,  destination text,origin text, departure_day timestamp,arrival_day timestamp) 
language plpgsql  
as  
$$ 
Begin 
   return query
   select flights.flight_id , flights.destination , flights.origin , flights.departure_day , flights.arrival_day  
   from flights join bookings using(flight_id) 
   join payment using(booking_id)
   join users using(user_id)
   where users.user_id = u_id ;  
End;  
$$;  

-- select *from trips(1);


//Write a function that by taking the required inputs (aircraft ID and time period) will 
show all the flights of a plane in a certain period.

create function get_flights(
    aircraft_id_selected INT,
    start_time_selected TIMESTAMP,
    end_time_selected TIMESTAMP
)
returns table ( flight_id int ,aircraft_id int,  destination text,origin text, departure_day timestamp,arrival_day timestamp) 
as $$
begin
   return query
   select flights.flight_id ,flights.aircraft_id, flights.destination , flights.origin , flights.departure_day , flights.arrival_day  
   from flights 
   where flights.aircraft_id = aircraft_id_selected 
   and flights.departure_day between  start_time_selected and end_time_selected 
   and flights.arrival_day between  start_time_selected and end_time_selected  ;  
end;
$$ language plpgsql;

-- select *from get_flights(5,'2023-01-01 15:00:00','2023-12-12 03:00:00');

--Write a function that takes the origin and destination as input and displays all flights with this origin and destination

CREATE OR REPLACE FUNCTION get_flights_by_origin_destination(input_destination text,input_origin text)

RETURNS TABLE (
    flight_id integer,
    destination text,
    origin text,
    departure_day timestamp,
    arrival_day timestamp,
    airport_id integer,
    aircraft_id integer,
    airline_id integer
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        flights.flight_id,
        flights.destination,
        flights.origin,
        flights.departure_day,
        flights.arrival_day,
        flights.airport_id,
        flights.aircraft_id,
        flights.airline_id
    FROM
        Flights
    WHERE
        flights.origin = input_origin AND flights.destination = input_destination;
END;
$$ LANGUAGE plpgsql;


-- select * from get_flights_by_origin_destination('Indonesia','Portugal')


//trigger

//Write a trigger so that a user who has not booked a flight and whose trip has not 
ended cannot register feedback about that flight.

CREATE OR REPLACE FUNCTION check_feedback()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM bookings
    join payment using(booking_id)
        WHERE bookings.flight_id = NEW.flight_id
        AND payment.user_id = NEW.user_id
    ) THEN
        RAISE EXCEPTION 'User must book the flight to provide feedback';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM flights
        WHERE flights.flight_id = NEW.flight_id
        AND flights.arrival_day < CURRENT_DATE
    ) THEN
        RAISE EXCEPTION 'Feedback can only be provided after the flight has ended';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_feedback_trigger
BEFORE INSERT
ON feedback
FOR EACH ROW
EXECUTE FUNCTION check_feedback();

--test1    
insert into Users (first_name, last_name, address_id, phone_number, password, email) values ('Jun', 'Grute', '46.11.205.236', '+389 846 556 0783', 'aT3WH#P}Lw@', 'jgrute0@engadget.com');
insert into feedback (user_id, flight_id, rating) values (61, 31, 9);
--test2
insert into Users (first_name, last_name, address_id, phone_number, password, email) values ('Zahra', 'Grute', '46.11.205.236', '+389 111 556 0783', 'aT3WH#P}Lw@', 'jgrute0@engadget.com');
insert into Flights (destination, origin, departure_day, arrival_day, airport_id, aircraft_id, airline_id) values ('Indonesia', 'Portugal', '2024-01-24 15:26:10', '2024-01-24 23:48:32', 4, 20, 2);
insert into Bookings (flight_id, booking_datetime, seat_num) values (51, '2024-01-23 18:29:47', 206);
insert into payment (user_id, booking_id, payment_date, price) values (62, 61, '2024-01-23 22:22:22', 205951.69);
insert into feedback (user_id, flight_id, rating) values (62, 51, 1);



//Write a trigger that a plane cannot make more than one flight in an hour.

create or replace function Check_the_flight_of_each_plane()
returns trigger as $$

declare
  last_flight timestamp;
begin
  select max(departure_day)
  into last_flight
  from Flights
  where aircraft_id = new.aircraft_id;

  if last_flight is not null and last_flight >= new.departure_day - interval '1' hour then
    raise exception 'An airplane cannot have more than one flight in one hour.';
  end if;
  return new;
end;
$$ language plpgsql;

create trigger Check_the_flight_of_each_plane
before insert on Flights
for each row
execute function Check_the_flight_of_each_plane() ;

--test
insert into Flights (destination, origin, departure_day, arrival_day, airport_id, aircraft_id, airline_id) values ('Indonesia', 'Portugal', '2024-01-24 15:26:10', '2024-01-24 23:48:32', 4, 20, 2);

--Write a trigger that prevents the user from booking a reserved seat on a flight.

create or replace function check_reserved_seat_trigger()
returns trigger as $$
begin
  if exists (
    select 1
    from Bookings 
    where bookings.flight_id = new.flight_id and bookings.seat_num = new.seat_num
  ) then
    raise exception'Seat % is already reserved for the specified flight.', new.seat_num;
  end if;

  return new;
end;
$$ language plpgsql;

create trigger prevent_reserved_seat
before insert on Bookings
for each row
execute function check_reserved_seat_trigger();

--test
insert into Bookings (flight_id, booking_datetime, seat_num) values (47, '2023-07-25 18:29:47', 206);

Stored procedure

//Create a Store Procedure that by getting a user ID and flight ID, add them to 
a reservation table.

create or replace procedure insert_reserve(u_id in integer,f_id in integer ,s_num in integer)
language 'plpgsql'
as $body$
declare
  b_id integer;
begin
   
    insert into Bookings(flight_id,booking_datetime,seat_num) values(f_id,Now(),s_num); 
  
  select booking_id from bookings where flight_id=f_id and booking_datetime=NOW() and seat_num=s_num
  into b_id;
  
    insert into payment (user_id,booking_id,payment_date,price)values(u_id,b_id,now(),4000);     
end;

$body$

-- call insert_reserve(5,10,98)

 //Create a Store Procedure that insert a new Crew to a flight.

create or replace procedure insert_crew(id in integer,first_name in varchar(255),last_name in varchar(255),gender in varchar(255),pos in varchar(255))
language 'plpgsql'
as $body$
declare
begin
  insert into Crew (airport_id, first_name, last_name, gender, position) values (id,first_name,last_name,gender,pos);
end;

$body$


--Create a Store Procedure that insert a payment for user

create or replace procedure insert_payment(u_id in integer,b_id in integer ,price in varchar(255))
language 'plpgsql'
as $body$
begin
   
    insert into payment(user_id,booking_id,payment_date,price) values(u_id,b_id,Now(),price); 
    
end;

$body$

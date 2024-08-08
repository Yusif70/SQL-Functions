create table Clubs(
	Id int primary key identity,
	Name nvarchar(50) not null,
	Wins tinyint,
	Draws tinyint,
	Losses tinyint,
	[Goals For] int,
	[Goals Against] int,
	Constraint in_range check(0 < Id and Id < 100)
)
create table Players(
	Id int primary key identity,
	[Shirt number] int not null,
	FullName nvarchar(50) not null,
	Goals int,
	ClubId int foreign key references Clubs(Id),
	Constraint in_range2 check(0 < [Shirt number] and [Shirt number] < 100)
)
create table Matches(
	Id int primary key identity,
	WeekNumber tinyint not null,
	[Home team Id] int foreign key references Clubs(Id),
	[Guest team Id] int foreign key references Clubs(Id),
	[Home team goals] int,
	[Guest team goals] int,
	Constraint not_same_clubs check([Home team Id] != [Guest team Id])
)
create table Goals(
	WeekNumber tinyint not null,
	PlayerId int foreign key references Players(id),
	Goals int
)
--1. Bitmis oyuna dair neticelerin daxil edilmesi (Procedure yazilacaq)
go
create or alter procedure insertClub(@Name nvarchar(50), @Wins tinyint, @Draws tinyint, @Losses tinyint, @GoalsFor int, @GoalsAgainst int)
as
begin
	insert into Clubs
	values(@Name, @Wins, @Draws, @Losses, @GoalsFor, @GoalsAgainst)
end
go
create or alter procedure insertPlayer(@ShirtNumber int, @FullName nvarchar(50), @Goals int, @ClubId int)
as
begin
	insert into Players
	values(@ShirtNumber, @FullName, @Goals, @ClubId)
end

go
create or alter procedure updatePlayer(@PlayerId int)
as
begin
	update Players
	set Goals = (select SUM(Goals) from Goals g 
	where g.PlayerId = @PlayerId)
	where Id = @PlayerId
end

go
create or alter procedure insertMatch(@WeekNumber tinyint, @HomeTeamId int, @GuestTeamId int, @HomeTeamGoals int, @GuestTeamGoals int)
as
begin
	insert into Matches
	values(@WeekNumber, @HomeTeamId, @GuestTeamId, @HomeTeamGoals, @GuestTeamGoals)

update Clubs
set [Goals For] = [Goals For] + (case when Id = @HomeTeamId then @HomeTeamGoals else @GuestTeamGoals end),
[Goals Against] = [Goals Against] + (case when Id = @HomeTeamId then @GuestTeamGoals else @HomeTeamGoals end)
where Id in (@HomeTeamId, @GuestTeamId)

update Clubs
set Wins = Wins + (case when @HomeTeamGoals > @GuestTeamGoals and Id = @HomeTeamId then 1
when @HomeTeamGoals < @GuestTeamGoals and Id = @GuestTeamId then 1
else 0
end),
Losses = Losses + (case when @HomeTeamGoals > @GuestTeamGoals and Id = @GuestTeamId then 1
when @HomeTeamGoals < @GuestTeamGoals and Id = @HomeTeamId then 1
else 0
end),
Draws = Draws + (case when @HomeTeamGoals = @GuestTeamGoals then 1 
else 0 end)
	where Id in (@HomeTeamId, @GuestTeamId)
end

go
create or alter procedure insertGoals(@WeekNumber tinyint, @PlayerId int, @Goals int)
as
begin
	insert into Goals
	Values(@WeekNumber, @PlayerId, @Goals)
end

exec insertClub @Name = 'Qarabag', @Wins = 0, @Draws = 0, @Losses = 0, @GoalsFor = 0, @GoalsAgainst = 0
exec insertClub @Name = 'Sabah', @Wins = 0, @Draws = 0, @Losses = 0, @GoalsFor = 0, @GoalsAgainst = 0
exec insertClub @Name = 'Zira', @Wins = 0, @Draws = 0, @Losses = 0, @GoalsFor = 0, @GoalsAgainst = 0
exec insertClub @Name = 'Neftci', @Wins = 0, @Draws = 0, @Losses = 0, @GoalsFor = 0, @GoalsAgainst = 0

exec insertPlayer @ShirtNumber = 10, @FullName = 'Abdullah Zubir', @Goals = 0, @ClubId = 1
exec insertPlayer @ShirtNumber = 18, @FullName = 'Olavio Juninyo', @Goals = 0, @ClubId = 1
exec insertPlayer @ShirtNumber = 8,  @FullName = 'Marko Yankovic', @Goals = 0, @ClubId = 1
exec insertPlayer @ShirtNumber = 7,  @FullName = 'Yassin Benzia', @Goals = 0, @ClubId = 1
exec insertPlayer @ShirtNumber = 90, @FullName = 'Nariman Axundzada', @Goals = 0, @ClubId = 1
exec insertPlayer @ShirtNumber = 44, @FullName = 'Elvin Cafarquliyev', @Goals = 0, @ClubId = 1
exec insertPlayer @ShirtNumber = 18, @FullName = 'Pavol Safranko', @Goals = 0, @ClubId = 2
exec insertPlayer @ShirtNumber = 20, @FullName = 'Mickels', @Goals = 0, @ClubId = 2
exec insertPlayer @ShirtNumber = 28, @FullName = 'Kaheem Parris', @Goals = 0, @ClubId = 2
exec insertPlayer @ShirtNumber = 70, @FullName = 'Jesse Sekidika', @Goals = 0, @ClubId = 2
exec insertPlayer @ShirtNumber = 88, @FullName = 'Xayal Aliyev', @Goals = 0, @ClubId = 2
exec insertPlayer @ShirtNumber = 2,  @FullName = 'Amin Seydiyev', @Goals = 0, @ClubId = 2
exec insertPlayer @ShirtNumber = 90, @FullName = 'Davit Volvov', @Goals = 0, @ClubId = 3
exec insertPlayer @ShirtNumber = 32, @FullName = 'Qismat Aliyev', @Goals = 0, @ClubId = 3
exec insertPlayer @ShirtNumber = 23, @FullName = 'Rafael Utzig', @Goals = 0, @ClubId = 3
exec insertPlayer @ShirtNumber = 19, @FullName = 'Salifu Sumah', @Goals = 0, @ClubId = 3
exec insertPlayer @ShirtNumber = 29, @FullName = 'Ceyhun Nuriyev', @Goals = 0, @ClubId = 3
exec insertPlayer @ShirtNumber = 41, @FullName = 'Anar Nazirov', @Goals = 0, @ClubId = 3
exec insertPlayer @ShirtNumber = 90, @FullName = 'Ramil Seydayev', @Goals = 0, @ClubId = 4
exec insertPlayer @ShirtNumber = 8,  @FullName = 'Emin Mahmudov', @Goals = 0, @ClubId = 4
exec insertPlayer @ShirtNumber = 2,  @FullName = 'Qara Qarayev', @Goals = 0, @ClubId = 4
exec insertPlayer @ShirtNumber = 10, @FullName = 'Filip Ozobic', @Goals = 0, @ClubId = 4
exec insertPlayer @ShirtNumber = 17, @FullName = 'Rehman Haciyev', @Goals = 0, @ClubId = 4
exec insertPlayer @ShirtNumber = 44, @FullName = 'Yuri Matias', @Goals = 0, @ClubId = 4

exec insertMatch @WeekNumber = 1, @HomeTeamId = 1, @GuestTeamId = 2, @HomeTeamGoals = 3, @GuestTeamGoals = 1
exec insertGoals @WeekNumber = 1, @Goals = 1,  @PlayerId = 1
exec insertGoals @WeekNumber = 1 , @Goals = 2, @PlayerId = 2
exec insertGoals @WeekNumber = 1 , @Goals = 1, @PlayerId = 7
exec updatePlayer @PlayerId = 1
exec updatePlayer @PlayerId = 2
exec updatePlayer @PlayerId = 7

exec insertMatch @WeekNumber = 1, @HomeTeamId = 3, @GuestTeamId = 4, @HomeTeamGoals = 2, @GuestTeamGoals = 1
exec insertGoals @WeekNumber = 1, @Goals = 2, @PlayerId = 13
exec insertGoals @WeekNumber = 1, @Goals = 1, @PlayerId = 19
exec updatePlayer @PlayerId = 13
exec updatePlayer @PlayerId = 19

exec insertMatch @WeekNumber = 2, @HomeTeamId = 3, @GuestTeamId = 1, @HomeTeamGoals = 0, @GuestTeamGoals = 2
exec insertGoals @WeekNumber = 2, @Goals = 2, @PlayerId = 2
exec updatePlayer @PlayerId = 2

exec insertMatch @WeekNumber = 2, @HomeTeamId = 2, @GuestTeamId = 4, @HomeTeamGoals = 2, @GuestTeamGoals = 2
exec insertGoals @WeekNumber = 2, @Goals = 1, @PlayerId = 8
exec insertGoals @WeekNumber = 2, @Goals = 1, @PlayerId = 9
exec insertGoals @WeekNumber = 2, @Goals = 1, @PlayerId = 22
exec insertGoals @WeekNumber = 2, @Goals = 1, @PlayerId = 20
exec updatePlayer @PlayerId = 8
exec updatePlayer @PlayerId = 9
exec updatePlayer @PlayerId = 22
exec updatePlayer @PlayerId = 20

exec insertMatch @WeekNumber = 3, @HomeTeamId = 1, @GuestTeamId = 4, @HomeTeamGoals = 4, @GuestTeamGoals = 1
exec insertGoals @WeekNumber = 3, @Goals = 2, @PlayerId = 2
exec insertGoals @WeekNumber = 3, @Goals = 2, @PlayerId = 3
exec insertGoals @WeekNumber = 3, @Goals = 1, @PlayerId = 22
exec updatePlayer @PlayerId = 2
exec updatePlayer @PlayerId = 3
exec updatePlayer @PlayerId = 22

exec insertMatch @WeekNumber = 3, @HomeTeamId = 2, @GuestTeamId = 3, @HomeTeamGoals = 3, @GuestTeamGoals = 2
exec insertGoals @WeekNumber = 3, @Goals = 2, @PlayerId = 10
exec insertGoals @WeekNumber = 3, @Goals = 1, @PlayerId = 7
exec insertGoals @WeekNumber = 3, @Goals = 1, @PlayerId = 13
exec insertGoals @WeekNumber = 3, @Goals = 1, @PlayerId = 15
exec updatePlayer @PlayerId = 10
exec updatePlayer @PlayerId = 7
exec updatePlayer @PlayerId = 13
exec updatePlayer @PlayerId = 15

--2. Bir komandanin cari veziyyetinin ve futbolcularinin siyahilanmasi (Procedure yazilacaq)
go
create or alter procedure getClubStats(@ClubName nvarchar(50))
as
begin
	select c.Name as Komanda, COUNT(m.WeekNumber) as O, c.Wins as G, c.Draws as H, c.Losses as M, c.[Goals For] as AQ, c.[Goals Against] as YQ, c.[Goals For] - c.[Goals Against] as AVR, c.Wins*3+c.Draws*1 as X from Clubs c
	join Matches m
	on c.Id in (m.[Guest team Id], m.[Home team Id])
	where c.Name = @ClubName
	group by c.Name, c.Wins, c.Draws, c.Losses, c.[Goals For], c.[Goals Against]
end

go
create or alter procedure getPlayerStats(@PlayerName nvarchar(50))
as
begin
	select p.[Shirt number] as [Forma No], p.FullName as [Ad Soyad], p.Goals as [AA] from Players p
	where p.FullName = @PlayerName
end

exec getClubStats @ClubName = 'Qarabag'

exec getPlayerStats @Playername = 'Olavio Juninyo'

--3. Puan cedvelinin siralanmasi (View yazilacaq)

create or alter view Standings
as 
select c.Name as Komanda, COUNT(m.WeekNumber) as O, c.Wins as Q, c.Draws as H, c.Losses as M, c.[Goals For] as AQ, c.[Goals Against] as YQ, c.[Goals For] - c.[Goals Against] as AVR, c.Wins*3 + c.Draws*1 as X from Clubs c
join Matches m
on c.Id in (m.[Home team Id], m.[Guest team Id])
group by c.Name, c.Wins, c.Draws, c.Losses, c.[Goals For], c.[Goals Against]

select * from Standings
order by X desc, AVR desc

--4. en cox qol atan ve en cox qol yiyen komandalarin siralanmasi (View yazilacaq)

create or alter view MostGoalScoringAndConcedingTeams
as
select c.Name as Komanda, c.[Goals For]as AQ, c.[Goals Against] as YQ from Clubs c
where c.[Goals For] = (select MAX([Goals For]) from Clubs) or c.[Goals Against] = (select MAX([Goals Against]) from Clubs)

select * from MostGoalScoringAndConcedingTeams
order by AQ desc

--5. Liqde en cox qol atan futbolcunun siralanmasi (View yazilacaq)

create or alter view Bombardiers
as
select c.Name as [Komanda Adi], p.[Shirt number] as [Forma No], p.FullName as [Ad Soyad], p.Goals as [Qol Sayi] from Players p
join Clubs c
on p.ClubId = c.Id
where p.Goals != 0

select * from Bombardiers
order by [Qol Sayi] desc
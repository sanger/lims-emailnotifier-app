insert into users values(1);
insert into studies values(1);
insert into tubes values (1, 'simple', 100);
insert into uuid_resources values(1, '11111111222233334444555555555555', 'user', 1);
insert into uuid_resources values(2, '11111111222233334444666666666666', 'study', 1);
insert into uuid_resources values(3, '11111111222233330000666666666666', 'tube', 1);

insert into samples values(1, "sample1");
insert into uuid_resources values(36, '11111111222233334444111111111111', 'sample', 1);

insert into tubes values (2, 'simple A', 100);
insert into tubes values (3, 'simple B', 100);
insert into tubes values (4, 'simple C', 100);
insert into uuid_resources values(13, '11111111222233330000777777777777', 'tube', 2);
insert into uuid_resources values(14, '11111111222233330000888888888888', 'tube', 3);
insert into uuid_resources values(15, '11111111222233330000999999999999', 'tube', 4);

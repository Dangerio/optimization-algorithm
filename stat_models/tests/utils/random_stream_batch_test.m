batch_size = 5;
loaders_count = 2;
first = 1;
size = 23;
pool = RandomStreamPool(batch_size, loaders_count, first, size);
loader_first = pool.get_loader(1);
loader_second = pool.get_loader(2);


prev = Inf;
for i = 1:5
    loader_first.pool.reset();
    assert(loader_first.get_batch_begin() == 1);
    s = loader_first.get_random_stream(i);
    new = randi(s, 2^30);
    assert(new ~= prev);
    prev = new;
end

prev = Inf;
for i = 1:5
    loader_second.pool.reset();
    assert(loader_second.get_batch_begin() == 6);
    s = loader_second.get_random_stream(i);
    new = randi(s, 2^30);
    assert(new ~= prev);
    prev = new;
end


loader_first.next();
assert(loader_first.get_batch_begin() == 11);
loader_second.next();
assert(loader_second.get_batch_begin() == 16);
loader_first.next();
assert(loader_first.get_batch_begin() == 21);
loader_first.next();
assert(loader_first.get_batch_begin() == 8);
loader_second.next();
assert(loader_second.get_batch_begin() == 3);


loader_first.pool.reset();
s = loader_first.get_random_stream(2);
num = randi(s, 2^30);
loader_first.pool.reset();
s = loader_first.get_random_stream(2);
same_num = randi(s, 2^30);
assert(num == same_num);
loader_first.pool.reset();
s = loader_first.get_random_stream(3);
other_num = randi(s, 2^30);
assert(num ~= other_num);


disp("Tests are passed!")

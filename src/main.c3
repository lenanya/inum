import inum;

fn int main()
{
    INum a, b, c;
    a.from_string("0")!!;
    b.from_string("1")!!;

    for (int i = 0; i < 1000; ++i) 
    {
        c = inum::add(a, b);
        a = b;
        b = c;
        a.printn();
    }

    return 0;
}
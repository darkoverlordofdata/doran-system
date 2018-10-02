using System.Collections.Generic;


public G[] VarArgs<G>(G car, va_list cdr)
{
    G[] array = { car };
    while (true)
    {
        var item = cdr.arg<G?>();
        if (item == null) break;

        array.resize(array.length+1);
        array[array.length-1] = item;
    }
    return array;
}

public void Test()
{
    _<int>( 1, 2, 3 )
    .Map<int>((x) => x+2 )
    .Each<int>((x) => print("1)number %d\n", x));

    int sum = _<int>( 1, 2, 3).Reduce<int>((m, n) => m+n, 0);

    print("Reduces to %d\n", sum);

    _<int>(1, 2, 3, 4, 5, 6, 7, 8)
    .Filter<int>((x) => x<5 || x>6 )
    .Each<int>((x, i) => print("%d = %d\n", i, x));
}

public static G[] ArrayOf<G>(G elem, ...)
{
    var p = va_list();
    G[] a = { elem };

    while (true)
    {
        var object = p.arg<G?>();
        if (object == null) break;

        a.resize(a.length+1);
        a[a.length-1] = object;
    }
    return a;
} 

public Underscore _<A>(A e, ...)
{
    var res = new Underscore<A>();
    res.data = { e };
    var e2 = va_list();
    while (true)
    {
        var value = e2.arg<A>();
        if (value == null) break;
        res.Add(value);
    }
    return res;
}

public delegate void UnderscoreEach<A>(A item, int index=-1);
public delegate A UnderscoreMap<A>(A item, int index=-1);
public delegate A UnderscoreReduce<A>(A memo, A item, int index=-1);
public delegate bool UnderscorePredicate<A>(A item, int index=-1);


public class Underscore<A> : Object
{
    public A[] data;

    public Underscore Add<A>(A value)
    {
        data.resize(data.length+1);
        data[data.length-1] = value;
        return this;
    }
    public void Each<A>(UnderscoreEach<A> f)
    {
        for (var index = 0; index < data.length; index++)
        {
            f<A>(data[index], index);
        }
    }
    public Underscore Map<A>(UnderscoreMap<A> f)
    {
        var res = new Underscore<A>();
        res.data = new A[data.length];
        for (var index = 0; index < data.length; index++)
        {
            res.data[index] = f<A>(data[index], index);
        }
        return res;
    }

    public A Reduce<A>(UnderscoreReduce<A> f, A memo)
    {
        A m = memo;
        for (var index = 0; index < data.length; index++)
        {
            m = f<A>(m, data[index], index);
        }
        return m;
    }

    public A Find<A>(UnderscorePredicate<A> f)
    {
        for (var index = 0; index < data.length; index++)
        {
            if (f<A>(data[index], index)) return data[index];
        }
        return null;
    }

    public Underscore Filter<A>(UnderscorePredicate<A> f)
    {
        var res = new Underscore<A>();
        for (var index = 0; index < data.length; index++)
        {
            if (f<A>(data[index], index)) 
            {
                res.Add(data[index]);
            }
        }
        return res;
    }

    public bool Every<A>(UnderscorePredicate<A> f)
    {
        for (var index = 0; index < data.length; index++)
        {
            if (!f<A>(data[index])) return false;
        }
        return true;
    }

    public bool Some<A>(UnderscorePredicate<A> f)
    {
        for (var index = 0; index < data.length; index++)
        {
            if (f<A>(data[index])) return true;
        }
        return false;
        
    }

}


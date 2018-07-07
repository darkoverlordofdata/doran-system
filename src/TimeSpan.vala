// namespace System 
// { 
    public class TimeSpan : Object 
    {
        public const int64    TicksPerMillisecond =  10000;
        private const double MillisecondsPerTick = 1.0 / TicksPerMillisecond;
 
        public const int64 TicksPerSecond = TicksPerMillisecond * 1000;   // 10,000,000
        private const double SecondsPerTick =  1.0 / TicksPerSecond;         // 0.0001
 
        public const int64 TicksPerMinute = TicksPerSecond * 60;         // 600,000,000
        private const double MinutesPerTick = 1.0 / TicksPerMinute; // 1.6666666666667e-9
 
        public const int64 TicksPerHour = TicksPerMinute * 60;        // 36,000,000,000
        private const double HoursPerTick = 1.0 / TicksPerHour; // 2.77777777777777778e-11
 
        public const int64 TicksPerDay = TicksPerHour * 24;          // 864,000,000,000
        private const double DaysPerTick = 1.0 / TicksPerDay; // 1.1574074074074074074e-12
 
        private const int MillisPerSecond = 1000;
        private const int MillisPerMinute = MillisPerSecond * 60; //     60,000
        private const int MillisPerHour = MillisPerMinute * 60;   //  3,600,000
        private const int MillisPerDay = MillisPerHour * 24;      // 86,400,000
 
        internal const int64 MaxSeconds = int64.MAX / TicksPerSecond;
        internal const int64 MinSeconds = int64.MIN / TicksPerSecond;
 
        internal const int64 MaxMilliSeconds = int64.MAX / TicksPerMillisecond;
        internal const int64 MinMilliSeconds = int64.MIN / TicksPerMillisecond;
 
        internal const int64 TicksPerTenthSecond = TicksPerMillisecond * 100;
 
        public static TimeSpan MaxValue; // = new TimeSpan(int64.MAX);
        public static TimeSpan MinValue; // = new TimeSpan(int64.MIN);
        public static TimeSpan Zero; // = new TimeSpan(0);
 
        internal int64 _ticks = 0;

        public static void Initialize() 
        {
            Zero = new TimeSpan(0);
            MaxValue = new TimeSpan(int64.MAX);
            MinValue = new TimeSpan(int64.MIN);
        }

        public TimeSpan(int64 ticks) 
        {
            this._ticks = ticks;
        }

        public int64 Ticks {
            get { return _ticks; }
        }
 
        public int Days {
            get { return (int)(_ticks / TicksPerDay); }
        }
 
        public int Hours {
            get { return (int)((_ticks / TicksPerHour) % 24); }
        }
 
        public int Milliseconds {
            get { return (int)((_ticks / TicksPerMillisecond) % 1000); }
        }
 
        public int Minutes {
            get { return (int)((_ticks / TicksPerMinute) % 60); }
        }
 
        public int Seconds {
            get { return (int)((_ticks / TicksPerSecond) % 60); }
        }
 
        public double TotalDays {
            get { return ((double)_ticks) * DaysPerTick; }
        }
 
        public double TotalHours {
            get { return (double)_ticks * HoursPerTick; }
        }
 
        public double TotalMilliseconds {
            get {
                double temp = (double)_ticks * MillisecondsPerTick;
                if (temp > MaxMilliSeconds)
                    return (double)MaxMilliSeconds;
 
                if (temp < MinMilliSeconds)
                    return (double)MinMilliSeconds;
 
                return temp;
            }
        }
 
        public double TotalMinutes {
            get { return (double)_ticks * MinutesPerTick; }
        }
 
        public double TotalSeconds {
            get { return (double)_ticks * SecondsPerTick; }
        }

        public TimeSpan Add(TimeSpan ts) {
            int64 result = _ticks + ts._ticks;
            // Overflow if signs of operands was identical and result's
            // sign was opposite.
            // >> 63 gives the sign bit (either 64 1's or 64 0's).
            if ((_ticks >> 63 == ts._ticks >> 63) && (_ticks >> 63 != result >> 63))
                throw new System.Exception.OverflowException(System.Environment.GetResourceString("Overflow_TimeSpanTooLong"));
            return new TimeSpan(result);
        }

        public void Plus(TimeSpan ts) {
            int64 result = _ticks + ts._ticks;
            // Overflow if signs of operands was identical and result's
            // sign was opposite.
            // >> 63 gives the sign bit (either 64 1's or 64 0's).
            if ((_ticks >> 63 == ts._ticks >> 63) && (_ticks >> 63 != result >> 63))
                throw new System.Exception.OverflowException(System.Environment.GetResourceString("Overflow_TimeSpanTooLong"));
            _ticks = result;
        }

        public void Minus(TimeSpan ts)
        {
            _ticks -= ts._ticks;
        }
        
        public TimeSpan Sub(TimeSpan ts)
        {
            int64 result = _ticks - ts._ticks;
            return new TimeSpan(result);
        }

        public bool LT(TimeSpan ts)
        {
            return _ticks < ts._ticks;
        }
        
        public bool LE(TimeSpan ts)
        {
            return _ticks <= ts._ticks;
        }

        public bool GT(TimeSpan ts)
        {
            return _ticks > ts._ticks;
        }
 
        public bool GE(TimeSpan ts)
        {
            return _ticks >= ts._ticks;
        }

        public bool NE(TimeSpan ts)
        {
            return _ticks != ts._ticks;
        }

        public bool EQ(TimeSpan ts)
        {
            return _ticks == ts._ticks;
        }
       // Compares two TimeSpan values, returning an integer that indicates their
        // relationship.
        //
        public static int Compare(TimeSpan t1, TimeSpan t2) {
            if (t1._ticks > t2._ticks) return 1;
            if (t1._ticks < t2._ticks) return -1;
            return 0;
        }
 
        // Returns a value less than zero if this  object
        public int CompareTo(Object value) {
            if (value == null) return 1;
            if (!(value is TimeSpan))
                throw new System.Exception.ArgumentException(System.Environment.GetResourceString("Arg_MustBeTimeSpan"));
            int64 t = ((TimeSpan)value)._ticks;
            if (_ticks > t) return 1;
            if (_ticks < t) return -1;
            return 0;
        }
 
         public static TimeSpan FromDays(double value) {
            return Interval(value, MillisPerDay);
        }
 
        public TimeSpan Duration() {
            if (Ticks==TimeSpan.MinValue.Ticks)
                throw new System.Exception.OverflowException(System.Environment.GetResourceString("Overflow_Duration"));
            // Contract.EndContractBlock();
            return new TimeSpan(_ticks >= 0? _ticks: -_ticks);
        }

        // public bool Equals(Object value) {
        //     return equals(value);
        // }

        public override bool Equals(Object value) {
            if (value is TimeSpan) {
                return _ticks == ((TimeSpan)value)._ticks;
            }
            return false;
        }
 
         public static TimeSpan FromHours(double value) {
            return Interval(value, MillisPerHour);
        }
 
        private static TimeSpan Interval(double value, int scale) {
            if (Math.isnan(value) != 0)
                throw new System.Exception.ArgumentException(System.Environment.GetResourceString("Arg_CannotBeNaN"));
            // Contract.EndContractBlock();
            double tmp = value * scale;
            double millis = tmp + (value >= 0? 0.5: -0.5);
            if ((millis > int64.MAX / TicksPerMillisecond) || (millis < int64.MIN / TicksPerMillisecond))
                throw new System.Exception.OverflowException(System.Environment.GetResourceString("Overflow_TimeSpanTooLong"));
            return new TimeSpan((long)millis * TicksPerMillisecond);
        }
 
         public static TimeSpan FromMilliseconds(double value) {
            return Interval(value, 1);
        }
 
        public static TimeSpan FromMinutes(double value) {
            return Interval(value, MillisPerMinute);
        }
 
        public TimeSpan Negate() {
            if (Ticks==TimeSpan.MinValue.Ticks)
                throw new System.Exception.OverflowException(System.Environment.GetResourceString("Overflow_NegateTwosCompNum"));
            // Contract.EndContractBlock();
            return new TimeSpan(-_ticks);
        }
 
        public static TimeSpan FromSeconds(double value) {
            return Interval(value, MillisPerSecond);
        }
 
        public TimeSpan Subtract(TimeSpan ts) {
            int64 result = _ticks - ts._ticks;
            // Overflow if signs of operands was different and result's
            // sign was opposite from the first argument's sign.
            // >> 63 gives the sign bit (either 64 1's or 64 0's).
            if ((_ticks >> 63 != ts._ticks >> 63) && (_ticks >> 63 != result >> 63))
                throw new System.Exception.OverflowException(System.Environment.GetResourceString("Overflow_TimeSpanTooLong"));
            return new TimeSpan(result);
        }
 
        public static TimeSpan FromTicks(int64 value) {
            return new TimeSpan(value);
        }
 
        // public string ToString(string format = "") {
        //     var t = new DateTime.from_unix_local(_ticks);
        //     return format == ""
        //         ? t.to_string()
        //         : t.format(format);
        // }

        // public string to_string(string format = "") {
        //     var t = new DateTime.from_unix_local(_ticks);
        //     return format == ""
        //         ? t.to_string()
        //         : t.format(format);
        // }

         

   }

// }
/* ******************************************************************************
 * Copyright 2018 darkoverlordofdata.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
namespace System.Diagnostics 
{
    using System;
 
    public class Stopwatch : Object
    {
        private const long TicksPerMillisecond = 10000;
        private const long TicksPerSecond = TicksPerMillisecond * 1000;
 
        private long elapsed;
        private uint64 startTimeStamp;
        private bool isRunning;
 
        // "Frequency" stores the frequency of the high-resolution performance counter, 
        // if one exists. Otherwise it will store TicksPerSecond. 
        // The frequency cannot change while the system is running,
        // so we only need to initialize it once. 
        public static uint64 Frequency;
        public static bool IsHighResolution;
 
        // performance-counter frequency, in counts per ticks.
        // This can speed up conversion from high frequency performance-counter 
        // to ticks. 
        private static double tickFrequency;  
 
        static construct {                    
            
            Frequency = Sdl.GetPerformanceFrequency();
            IsHighResolution = true;
            tickFrequency = TicksPerSecond;
            tickFrequency /= Frequency;
   
        }
 
        public Stopwatch() {
            Reset();
        }
 
        public void Start() {
            // Calling start on a running Stopwatch is a no-op.
            if(!isRunning) {
                startTimeStamp = GetTimestamp();                 
                isRunning = true;
            }
        }
 
        public static Stopwatch StartNew() {
            Stopwatch s = new Stopwatch();
            s.Start();
            return s;
        }
 
        public void Stop() {
            // Calling stop on a stopped Stopwatch is a no-op.
            if( isRunning) {
                uint64 endTimeStamp = GetTimestamp();                 
                uint64 elapsedThisPeriod = endTimeStamp - startTimeStamp;
                elapsed += (long)elapsedThisPeriod;
                isRunning = false;
 
                if (elapsed < 0) {
                    // When measuring small time periods the StopWatch.Elapsed* 
                    // properties can return negative values.  This is due to 
                    // bugs in the basic input/output system (BIOS) or the hardware
                    // abstraction layer (HAL) on machines with variable-speed CPUs
                    // (e.g. Intel SpeedStep).
 
                    elapsed = 0;
                }
            }
        }
 
        public void Reset() {
            elapsed = 0;
            isRunning = false;
            startTimeStamp = 0;
        }
 
        // Convenience method for replacing {sw.Reset(); sw.Start();} with a single sw.Restart()
        public void Restart() {
            elapsed = 0;
            startTimeStamp = GetTimestamp();
            isRunning = true;
        }
 
        public bool IsRunning { 
            get { return isRunning; }
        }
 
        public TimeSpan Elapsed {
            owned get { return new TimeSpan( GetElapsedDateTimeTicks()); }
        }
        
        
        public long ElapsedMilliseconds { 
            get { return GetElapsedDateTimeTicks()/TicksPerMillisecond; }    
        }  
        
        public long ElapsedTicks { 
            get { return GetRawElapsedTicks(); }
        }
 
        public static uint64 GetTimestamp() {

		    return Sdl.GetPerformanceCounter();
        }
 
        // Get the elapsed ticks.        
        private long GetRawElapsedTicks() {
            long timeElapsed = elapsed;
 
            if( isRunning) {
                // If the StopWatch is running, add elapsed time since
                // the Stopwatch is started last time. 
                uint64 currentTimeStamp = GetTimestamp();                 
                uint64 elapsedUntilNow = currentTimeStamp - startTimeStamp;
                timeElapsed += (long)elapsedUntilNow;
            }
            return timeElapsed;
        }   
 
        // Get the elapsed ticks.        
        private long GetElapsedDateTimeTicks() {
            long rawTicks = GetRawElapsedTicks();
            if( IsHighResolution) {
                // convert high resolution perf counter to DateTime ticks
                double dticks = rawTicks;
                dticks *= tickFrequency;
                return (long)dticks;                        
            }
            else {
                return rawTicks;
            }
        }   
 
    }
}

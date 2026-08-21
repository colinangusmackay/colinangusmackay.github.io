---
title: "Building messages in parallel"
slug: building-messages-in-parallel
publishDate: 25 May 2011
description: "I recently saw some code where the developer was attempting to build up messages inside tasks that were being reported outside of the task. In a sequential..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "ConcurrentBag", slug: concurrentbag }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "shared data", slug: shared-data }
---
I recently saw some code where the developer was attempting to build up messages inside tasks that were being reported outside of the task.

In a sequential system it is easy enough to do this. You have various options available to you, such as

- message += …;
- StringBuilder
- Streams

However, in a parallel system these all fall down because you lose control over the sequencing. You can regain some control by using appropriate locks but then you add in bottlenecks around the synchronisation points which is something you want to minimise in a parallel system.

I’ll show you what I mean. Each example below is attempting to build up a large message containing messages from smaller subroutines. For the moment, let’s assume that the exact order of the individual messages are not important. It may be a series of log entries, or a list of errors to correct. The only important thing is that each individual message is not garbled in anyway. <sup>\[[Skip the code](#2011-05-25-22-29-Skip-Code)\]</sup>

The example message is actually just a set of letters and numbers. In the final message each letter must appear 10 times and each number 26 times. Once the tasks have finished, the final messages are examined to see what happened.

### Sequential Reference code

Here is the code:

```csharp
class Program
{
    static void Main(string[] args)
    {
        string result = SequentialReference();

        ShowResult(result);

        Console.WriteLine("Program finished");
        Console.ReadLine();
    }

    private static string SequentialReference()
    {
        string result = string.Empty;

        for(int i=0; i<10; i++)
        {
            for(char c='A'; c<='Z'; c++)
            {
                result += string.Format("{0}{1}", i, c);
            }
            result += Environment.NewLine;
        }

        return result;
    }

    private static void ShowResult(string message)
    {
        // Code to display the message and the
        // results of the tests
    }
}
```

The code generates the messages, then outputs the results. For the reference sequential code (which is what we want all the results to look like) we get:

<span id="2011-05-25-23-42-Sequential-Reference-Output"></span>

```
0A0B0C0D0E0F0G0H0I0J0K0L0M0N0O0P0Q0R0S0T0U0V0W0X0Y0Z
1A1B1C1D1E1F1G1H1I1J1K1L1M1N1O1P1Q1R1S1T1U1V1W1X1Y1Z
2A2B2C2D2E2F2G2H2I2J2K2L2M2N2O2P2Q2R2S2T2U2V2W2X2Y2Z
3A3B3C3D3E3F3G3H3I3J3K3L3M3N3O3P3Q3R3S3T3U3V3W3X3Y3Z
4A4B4C4D4E4F4G4H4I4J4K4L4M4N4O4P4Q4R4S4T4U4V4W4X4Y4Z
5A5B5C5D5E5F5G5H5I5J5K5L5M5N5O5P5Q5R5S5T5U5V5W5X5Y5Z
6A6B6C6D6E6F6G6H6I6J6K6L6M6N6O6P6Q6R6S6T6U6V6W6X6Y6Z
7A7B7C7D7E7F7G7H7I7J7K7L7M7N7O7P7Q7R7S7T7U7V7W7X7Y7Z
8A8B8C8D8E8F8G8H8I8J8K8L8M8N8O8P8Q8R8S8T8U8V8W8X8Y8Z
9A9B9C9D9E9F9G9H9I9J9K9L9M9N9O9P9Q9R9S9T9U9V9W9X9Y9Z

Does the result contain all the necessary parts?
10 of each letter; 26 of each number
0: 26 occurrences: Pass
1: 26 occurrences: Pass
2: 26 occurrences: Pass
3: 26 occurrences: Pass
4: 26 occurrences: Pass
5: 26 occurrences: Pass
6: 26 occurrences: Pass
7: 26 occurrences: Pass
8: 26 occurrences: Pass
9: 26 occurrences: Pass
A: 10 occurrences: Pass
B: 10 occurrences: Pass
C: 10 occurrences: Pass
D: 10 occurrences: Pass
E: 10 occurrences: Pass
F: 10 occurrences: Pass
G: 10 occurrences: Pass
H: 10 occurrences: Pass
I: 10 occurrences: Pass
J: 10 occurrences: Pass
K: 10 occurrences: Pass
L: 10 occurrences: Pass
M: 10 occurrences: Pass
N: 10 occurrences: Pass
O: 10 occurrences: Pass
P: 10 occurrences: Pass
Q: 10 occurrences: Pass
R: 10 occurrences: Pass
S: 10 occurrences: Pass
T: 10 occurrences: Pass
U: 10 occurrences: Pass
V: 10 occurrences: Pass
W: 10 occurrences: Pass
X: 10 occurrences: Pass
Y: 10 occurrences: Pass
Z: 10 occurrences: Pass
Does the result contain correctly sequenced individual messages?
Each sequence 52 chars; 0A0B0C... 1A1B1C.... etc.
Message 0: PASS - 52 char; PASS - Message content as expected
Message 1: PASS - 52 char; PASS - Message content as expected
Message 2: PASS - 52 char; PASS - Message content as expected
Message 3: PASS - 52 char; PASS - Message content as expected
Message 4: PASS - 52 char; PASS - Message content as expected
Message 5: PASS - 52 char; PASS - Message content as expected
Message 6: PASS - 52 char; PASS - Message content as expected
Message 7: PASS - 52 char; PASS - Message content as expected
Message 8: PASS - 52 char; PASS - Message content as expected
Message 9: PASS - 52 char; PASS - Message content as expected
Program finished
```

### String Concatenation in parallel

The first bad parallel example is this one, where the message is built up using string concatenation.  The code is almost identical to the sequential example, except that the for loop is now a Parallel.For and I’ve injected a Sleep to simulate performing other work (such as getting the data necessary to build the messages).

```csharp
class Program
{
    static void Main(string[] args)
    {
        string message = StringConcat();

        ShowResult(message);

        Console.WriteLine("Program finished");
        Console.ReadLine();
    }

    private static string StringConcat()
    {
        string result = string.Empty;

        Parallel.For(0, 10,
                        (int i) =>
                            {
                                for (char c = 'A'; c <= 'Z'; c++)
                                {
                                    result += string.Format("{0}{1}",i, c);
                                    Thread.Sleep(15);
                                }
                                result += Environment.NewLine;
                            });

        return result;
    }
}
```

And the results are starkly different:

```
0A2A4A6A8A2B0B6B4B8B2C0C6C8C2D0D6D4D8D2E0E4E8E2F0F4F6F8F2G0G4G6G8G2H0H4H8H2I0I4I
8I2J0J6J4J8J2K0K4K8K2L0L6L4L8L2M0M6M8M2N0N4N8N2O0O4O8O2P0P6P4P8P2Q0Q4Q8Q2R0R6R4R
8R2S0S6S4S8S2T0T4T8T2U0U4U8U2V0V6V4V8V2W0W6W8W2X0X6X8X2Y0Y4Y8Y2Z0Z4Z6Z8Z
3A
1A
5A
7A
9A3B1B5B7B9B3C1C7C9C3D1D5D9D3E1E7E9E3F1F5F7F9F3G1G5G9G3H1H5H9H3I1I7I5I9I3J1J7J9J
3K1K5K7K9K3L1L7L5L9L3M1M5M9M3N1N5N7N9N3O1O5O7O9O3P1P7P9P3Q1Q7Q5Q9Q3R1R7R5R9R1S3S
7S5S9S3T1T5T7T9T3U7U5U9U1V5V9V3W7W9W1X3X7X5X9X3Y1Y7Y5Y9Y1Z7Z9Z

Does the result contain all the necessary parts?
10 of each letter; 26 of each number
0: 26 occurrences: Pass
1: 24 occurrences: Fail
2: 26 occurrences: Pass
3: 24 occurrences: Fail
4: 22 occurrences: Fail
5: 20 occurrences: Fail
6: 16 occurrences: Fail
7: 21 occurrences: Fail
8: 26 occurrences: Pass
9: 26 occurrences: Pass
A: 10 occurrences: Pass
B: 10 occurrences: Pass
C: 8 occurrences: Fail
D: 9 occurrences: Fail
E: 8 occurrences: Fail
F: 10 occurrences: Pass
G: 9 occurrences: Fail
H: 8 occurrences: Fail
I: 9 occurrences: Fail
J: 9 occurrences: Fail
K: 9 occurrences: Fail
L: 10 occurrences: Pass
M: 8 occurrences: Fail
N: 9 occurrences: Fail
O: 9 occurrences: Fail
P: 9 occurrences: Fail
Q: 9 occurrences: Fail
R: 10 occurrences: Pass
S: 10 occurrences: Pass
T: 9 occurrences: Fail
U: 8 occurrences: Fail
V: 8 occurrences: Fail
W: 7 occurrences: Fail
X: 9 occurrences: Fail
Y: 9 occurrences: Fail
Z: 8 occurrences: Fail
Does the result contain correctly sequenced individual messages?
Each sequence 52 chars; 0A0B0C... 1A1B1C.... etc.
Message 0: FAIL - Expected 52 / Got 232 characters
Message 1: FAIL - Expected 52 / Got 2 characters
Message 2: FAIL - Expected 52 / Got 2 characters
Message 3: FAIL - Expected 52 / Got 2 characters
Message 4: FAIL - Expected 52 / Got 2 characters
Message 5: FAIL - Expected 52 / Got 222 characters
Program finished
```

As you can see, some of it works out... Most of it is a mess!

### <span id="2011-05-25-22-29-Skip-Code"></span>So what happened?

The `string` that will contain the result was created outside of the parallel tasks. Inside the tasks the result was updated without any synchronisation structure in place. That means that all the tasks could update the intermediate stages of the result and in the process overwrite each others changes, insert items out of sequence and so on.

I’ve written about some of ways that the Parallel Extensions can help with synchronisation of data across parallel tasks before (e.g. [the `ConcurrentDictionary` being used to help with the aggregation of grouped counts](/2011/03/24/parallelisation-in-net-4-0-the-concurrent-dictionary/ "Grouping and counting each type of word in Grimm's Fairy Tales with the help of the ConcurrentDictionary")) so perhaps here is an example of where another of the concurrent collections may come in handy. A `ConcurrentBag` could be used to hold each of the individual completed messages.

A `ConcurrentBag` is an unordered collection of objects that you can access across multiple threads in a safe way. You can add the same object to the bag as many times as you like. As it is unordered you cannot rely on the objects being retrieved in any particular sequence.

The code that builds the messages now looks like this:

```csharp
private static string ConcurrentBagExample()
{
    ConcurrentBag<string> bag = new ConcurrentBag<string>();

    Parallel.For(0, 10,
                    (i) =>
                    {
                        string result = string.Empty;
                        for (char c = 'A'; c <= 'Z'; c++)
                        {
                            result += string.Format("{0}{1}", i, c);
                            Thread.Sleep(15);
                        }
                        bag.Add(result);
                    });

    return string.Join(Environment.NewLine, bag);
}
```

What has changed is that the building of the `string` has moved inside the task. This means that the task can only build the `string` for itself. Once it is done the `string` is added to the `ConcurrentBag`. The final `string` is built outside the parallel tasks. At the end of the method a simple `string.Join()` is used to pull all the data that's been built up in the `ConcurrentBag`.

And now the messages are formed correctly. The only difference between the output of this program and that of the sequential reference program <sup>\[[see above](#2011-05-25-23-42-Sequential-Reference-Output)\]</sup> is the ordering of the individual messages:

```
1A1B1C1D1E1F1G1H1I1J1K1L1M1N1O1P1Q1R1S1T1U1V1W1X1Y1Z
0A0B0C0D0E0F0G0H0I0J0K0L0M0N0O0P0Q0R0S0T0U0V0W0X0Y0Z
3A3B3C3D3E3F3G3H3I3J3K3L3M3N3O3P3Q3R3S3T3U3V3W3X3Y3Z
2A2B2C2D2E2F2G2H2I2J2K2L2M2N2O2P2Q2R2S2T2U2V2W2X2Y2Z
5A5B5C5D5E5F5G5H5I5J5K5L5M5N5O5P5Q5R5S5T5U5V5W5X5Y5Z
4A4B4C4D4E4F4G4H4I4J4K4L4M4N4O4P4Q4R4S4T4U4V4W4X4Y4Z
7A7B7C7D7E7F7G7H7I7J7K7L7M7N7O7P7Q7R7S7T7U7V7W7X7Y7Z
6A6B6C6D6E6F6G6H6I6J6K6L6M6N6O6P6Q6R6S6T6U6V6W6X6Y6Z
9A9B9C9D9E9F9G9H9I9J9K9L9M9N9O9P9Q9R9S9T9U9V9W9X9Y9Z
8A8B8C8D8E8F8G8H8I8J8K8L8M8N8O8P8Q8R8S8T8U8V8W8X8Y8Z
```

---
title: "Code Review: Making a drop down list out of an enum"
slug: code-review
publishDate: 20 Apr 2015
description: "I’ve come across code like this a couple of times and it is rather odd: IEnumerable<CalendarViewEnum> _calendarViewEnums =..."
tags:
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "C#", slug: c }
  - { name: "Code Quality", slug: code-quality }
  - { name: "refactoring", slug: refactoring }
---
I’ve come across code like this a couple of times and it is rather odd:

```csharp
IEnumerable<CalendarViewEnum> _calendarViewEnums =
    Enum.GetValues(typeof(CalendarViewEnum)).Cast<CalendarViewEnum>();
List selectList = new List<SelectListItem>();
foreach (CalendarViewEnum calendarViewEnum in _calendarViewEnums)
{
  switch (calendarViewEnum)
  {
    case CalendarViewEnum.FittingRoom:
      selectList.Add(new SelectListItem { 
          Text = AdminPreferencesRes.Label_CalendarViewFittingRoom, 
          Value = ((int)calendarViewEnum).ToString(CultureInfo.InvariantCulture), 
          Selected = (calendarViewEnum == CalendarViewEnum.FittingRoom) 
          });
      break;
    case CalendarViewEnum.Staff:
      selectList.Add(new SelectListItem { 
          Text = AdminPreferencesRes.Label_CalendarViewStaff, 
          Value = ((int)calendarViewEnum).ToString(CultureInfo.InvariantCulture), 
          Selected = (calendarViewEnum == CalendarViewEnum.Staff) 
      });
    break;
    case CalendarViewEnum.List:
      selectList.Add(new SelectListItem { 
          Text = AdminPreferencesRes.Label_CalendarViewList, 
          Value = ((int)calendarViewEnum).ToString(CultureInfo.InvariantCulture), 
          Selected = (calendarViewEnum == CalendarViewEnum.List) 
      });
    break;
    default:
      throw new Exception("CalendarViewEnum Enumeration does not exist");
  }
  return selectList.ToArray();
}
```

So, what this does is it generates a list of values from an enum, then it loops around that list generating a second list of `SelectListItem`s (for a drop down list box on the UI). Each item consists of a friendly name (to display to the user), a integer value (which is returned to the server on selection) and a Boolean value representing whether that item is selected (which is actually always true, so it is lucky that MVC ignores this the way the Drop Down List was rendered, otherwise it would get very confused.)

Each loop only has one possible path (but the runtime doesn’t know this, so it slavishly runs through the switch statement each time). So that means we can do a lot to optimise and simplify this code.
Here it is:

```csharp
List<SelectListItem> selectList = new List<SelectListItem>();
selectList.Add(new SelectListItem { 
    Text = AdminPreferencesRes.Label_CalendarViewFittingRoom, 
    Value = ((int) CalendarViewEnum.FittingRoom).ToString(CultureInfo.InvariantCulture) 
  });
selectList.Add(new SelectListItem { 
    Text = AdminPreferencesRes.Label_CalendarViewStaff, 
    Value = ((int)CalendarViewEnum.Staff).ToString(CultureInfo.InvariantCulture) 
  });
selectList.Add(new SelectListItem { 
    Text = AdminPreferencesRes.Label_CalendarViewList, 
    Value = ((int)CalendarViewEnum.List).ToString(CultureInfo.InvariantCulture) 
  });
return selectList.ToArray();
```

There is one other another bit of refactoring we can do. We always, without exception, return the same things from this method and it is a known fixed size at compile time. So, let’s just generate the array directly:

```csharp
return new []
{
  new SelectListItem { 
      Text = AdminPreferencesRes.Label_CalendarViewFittingRoom, 
      Value = ((int) CalendarViewEnum.FittingRoom).ToString(CultureInfo.InvariantCulture) 
    },
  new SelectListItem { 
      Text = AdminPreferencesRes.Label_CalendarViewStaff, 
      Value = ((int)CalendarViewEnum.Staff).ToString(CultureInfo.InvariantCulture) 
    },
  new SelectListItem { 
      Text = AdminPreferencesRes.Label_CalendarViewList, 
      Value = ((int)CalendarViewEnum.List).ToString(CultureInfo.InvariantCulture) 
    }
};
```

So, in the end a redundant loop has been removed and a redundant conversion from list to array has been removed. The code is also easier to read and easier to maintain. It is easier to read because the [cyclomatic complexity](http://en.wikipedia.org/wiki/Cyclomatic_complexity) of the method is now one, previously it was 5 (one for the loop, and one for each case clause in the switch statement \[assuming I've calculated it correctly\]). The lower the cyclomatic complexity of a method is the easier it is to understand and maintain as there are less conditions to deal with. It is easier to maintain because now instead of a whole new case statement to be added to the switch statement a single line just needs to be added to the array. The redundant Selected property has also been removed.

There are still ways to improve this, but the main issue (what that loop is actually doing) for anyone maintaining this code has now been resolved.

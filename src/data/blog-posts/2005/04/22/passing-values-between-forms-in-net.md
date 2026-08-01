---
title: "Passing Values Between Forms in .NET"
slug: passing-values-between-forms-in-net
publishDate: 22 Apr 2005
description: "Introduction I wrote this article in response to an almost overwhelming number of requests on forums on how to pass a variable from a one Windows Form to..."
tags:
  - { name: "Beginners", slug: beginners }
  - { name: "C#", slug: c }
  - { name: "VB.NET", slug: vb-net }
  - { name: "WinForms", slug: winforms }
---
### Introduction

I wrote this article in response to an almost overwhelming number of requests on forums on how to pass a variable from a one Windows Form to another. In fact, saying that it is going between one form and another is somewhat of a misnomer because this will work for any type of object not just Forms. This seems to be one area where beginners in C# and VB.NET often get stuck. So, rather than having to repeat myself often in forums I wrote this article so that I could point people at it so that they will have the benefit of a full explanation as well as the answer to their problem.
The code examples that come with this article are available for VB.NET and C# so that neither group feels left out. If you develop software in any of the other languages available for .NET then you can probably follow on too. The techniques are the same for all .NET languages the only difference should be in the language syntax.

### Parent to child

Passing a value from a parent to a child class is hopefully one of the easiest techniques and is the one I'll start with. The idea is simple. The parent class needs to pass some value to the child class. In this example, I have set up a simple parent form with a `TextBox` control where the user can type any value they like, then they can open the child form and see that value appear there.
First of all, the child class needs some way to receive the value from the parent. I've set up a property to receive the value and it will set the `Text` value of a `TextBox` on the child form. In reality this could set a field value or get passed to another object and so on.

##### C#

```csharp
public string ValueFromParent
{
    set
    {
        this.uxParentValue.Text = value;
    }
}
```

##### VB.NET

```vb
Public WriteOnly Property ValueFromParent() As String
    Set(ByVal Value As String)
        Me.uxParentValue.Text = Value
    End Set
End Property
```

#### Passing the value on construction

To make the initialization of the class easier, the constructor will take a parameter which will be the current value to be passed. The constructor uses the property so that the code can be reused. Admittedly, in this example there is only one line in the property, but as an element of future proofing it means that there is the possibility of adding more functionality to the property in future should it need. That additional functionality will be implemented without having to change a lot of existing code.

##### C#

```csharp
public ChildForm(string initialValue)
{
    InitializeComponent();
    ValueFromParent = initialValue;
}
```

##### VB.NET

```vb
Public Sub New(ByVal initialValue As String)
    MyBase.New()
    'This call is required by the Windows Form Designer.
    InitializeComponent()
    ValueFromParent = initialValue
End Sub
```

Now, in order for the parent to pass the value to the child, it only has to set the property. For example, when using the child form as a dialog the value from the parent can be passed as follows:

##### C#

```csharp
private void uxOpenDialog_Click(object sender, System.EventArgs e)
{
    // Get the value to be passed
    string parentValue = this.uxUserResponse.Text;
    // Create the child form.
    ChildForm child = new ChildForm(parentValue);
    // Show the form which will display the user's value.
    child.ShowDialog();
}
```

##### VB.NET

```vb
Private Sub uxOpenDialog_Click(ByVal sender As System.Object, _
    ByVal e As System.EventArgs) Handles uxOpenDialog.Click
    ' Get the value that the child will be initialised with
    Dim initialValue As String
    initialValue = Me.uxUserResponse.Text
    Dim childForm As ChildForm
    ' Create the child form.
    childForm = New ChildForm(initialValue)
    ' Show the child dialog.
    childForm.ShowDialog()
End Sub
```

#### Passing the value while the form is open

Of course, it may be necessary to pass a value when the child form is already open. This is also possible if the parent form stores a reference to the child form and then uses that to pass updates to the child form using the property in the child form that was set up earlier.
In my example, the parent is going to store a reference to the child as a field in the `ParentForm` class like this:

##### C#

```csharp
private ChildForm uxChildForm;
```

##### VB.NET

```vb
Private uxChildForm As ChildForm
```

When creating the child form it is therefore important to pass the reference to the child form into the field variable. For example:

##### C#

```csharp
private void uxOpenForm_Click(object sender, System.EventArgs e)
{
    this.uxChildForm = new ChildForm();
    this.uxChildForm.ValueFromParent = this.uxUserResponse.Text;
    this.uxChildForm.Show();
}
```

##### VB.NET

```vb
Private Sub uxOpenForm_Click(ByVal sender As System.Object, _
    ByVal e As System.EventArgs) Handles uxOpenForm.Click
    Me.uxChildForm = New ChildForm
    Me.uxChildForm.ValueFromParent = Me.uxUserResponse.Text
    Me.uxChildForm.Show()
End Sub
```

Finally, whenever the parent needs to tell the child that the value is updated it can do so just by passing the new value to the property that was set up in the child form. For example:

##### C#

```csharp
private void uxUserResponse_TextChanged(object sender, System.EventArgs e)
{
    if (this.uxChildForm != null)
    {
        this.uxChildForm.ValueFromParent = this.uxUserResponse.Text;
    }
}
```

##### VB.NET

```vb
Private Sub uxUserResponse_TextChanged(ByVal sender As System.Object, _
    ByVal e As System.EventArgs) Handles uxUserResponse.TextChanged
    If Not Me.uxChildForm Is Nothing Then
        Me.uxChildForm.ValueFromParent = Me.uxUserResponse.Text
    End If
End Sub
```

The code for this is in the zip file above. The projects are ParentToChildCS (for C# developers) and ParentToChildVB (for VB developers).

### Sibling to Sibling

The next most common request seems to be passing a value between two siblings. That is, two child classes sharing the same parent class. This also demonstrates passing between the child and the parent.
First, it is important to note that in most cases the two child classes should probably know nothing about each other. If the two child classes start to communicate directly with each other the coupling in the application increases and this will make maintenance of the application more difficult. Therefore the first thing to do is to allow the child classes to raise events when they change.
In order to raise events, create a delegate to define the signature of the method that will be called when the event is raised. It is a good practice to conform to the same style as the delegates used in the .NET Framework itself. For example, if an event handler for the `Click` event of a Button is created then it is possible to see that the signature of the method created by the IDE has two parameters, `sender` and `e`. `sender` is an object and is a reference to the object that generated the event. `e` is the `EventArgs` (or a something derived from `EventArgs`).
With that in mind, the delegate created here will have `sender` and `e` parameters as well. But for the `e` parameter a new class will be created to store the specific details of the event.

##### C#

```csharp
public class ValueUpdatedEventArgs : System.EventArgs
{
    // Stores the new value.
    private string newValue;
    // Create a new instance of the
    // ValueUpdatedEventArgs class.
    // newValue represents the change to the value.
    public ValueUpdatedEventArgs(string newValue)
    {
        this.newValue = newValue;
    }
    // Gets the updated value.
    public string NewValue
    {
        get
        {
            return this.newValue;
        }
    }
}
```

##### VB.NET

```vb
Public Class ValueUpdatedEventArgs
    Inherits System.EventArgs
    ' Stores the new value
    Dim _newValue As String
    ' Create a new instance of the
    ' ValueUpdatedEventArgs class.
    ' newValue represents the change to the value.
    Public Sub New(ByVal newValue As String)
        MyBase.New()
        Me._newValue = newValue
    End Sub
    ' Gets the updated value
    ReadOnly Property NewValue() As String
    Get
        Return Me._newValue
    End Get
    End Property
End Class
```

Next the delegate needs to be defined.

##### C#

```csharp
public delegate void ValueUpdated(object sender,
    ValueUpdatedEventArgs e);
```

##### VB.NET

```vb
Public Delegate Sub ValueUpdated(ByVal sender As Object, _
    ByVal e As ValueUpdatedEventArgs)
```

Now that the foundation of the mechanism for informing other objects of changes is written, the child classes can implement the raising of events so that observers (i.e. interested parties) can be notified when the value changes.
In the class for the child forms the event `ValueUpdated` is declared so that interested parties can indicate what they want to observe.

##### C#

```csharp
public event ValueUpdated ValueUpdated;
```

This is one area where C# and VB.NET differ. In C# an event requires a delegate, whereas in VB.NET the signature of the method to be called needs to be declared as part of the event. The advantage for C# is that the delegate only has to be declared once and it can be reused in many places whereas VB.NET has to have essentially the same bit of code, the method signature, rewritten frequently - this can be an area where there can be discrepancies between one class and another.
Next, when the child class is updated it needs to inform its observers (the interested parties, in this case it will be the parent and sibling forms). The following code shows what happens when the text is changed on the form.

##### C#

```csharp
private void uxMyValue_TextChanged(object sender, System.EventArgs e)
{
    // Get the new value from the text box
    string newValue = this.uxMyValue.Text;
    // Create the event args object.
    ValueUpdatedEventArgs valueArgs =
    new ValueUpdatedEventArgs(newValue);
    // Inform the observers.
    ValueUpdated(this, valueArgs);
}
```

##### VB.NET

```vb
Private Sub uxMyValue_TextChanged(ByVal sender As System.Object, _
    ByVal e As System.EventArgs) Handles uxMyValue.TextChanged
    Dim newValue As String
    newValue = Me.uxMyValue.Text
    Dim valueArgs As ValueUpdatedEventArgs
    valueArgs = New ValueUpdatedEventArgs(newValue)
    RaiseEvent ValueUpdated(Me, valueArgs)
End Sub
```

Now that the child form can inform others of the changes and what the changes are, the parent needs to open the child form and register as an observer so that it can be informed when changes are made. The parent will also ensure that other siblings that are interested get added as observers too.

##### C#

```csharp
private void uxOpenChildA_Click(object sender, System.EventArgs e)
{
    // Create the child form
    this.childA = new ChildAForm();
    // Add an event so that the parent form is informed when the child
    // is updated.
    this.childA.ValueUpdated += new ValueUpdated(childA_ValueUpdated);
    // Add an event to each child form so that they are notified of each
    // others changes.
    if (this.childB != null)
    {
        this.childA.ValueUpdated +=
            new ValueUpdated(this.childB.childA_ValueUpdated);
        this.childB.ValueUpdated +=
            new ValueUpdated(this.childA.childB_ValueUpdated);
    }
    this.childA.Show();
}
```

##### VB.NET

```vb
Private Sub uxOpenChildA_Click(ByVal sender As System.Object, _
    ByVal e As System.EventArgs) Handles uxOpenChildA.Click
    ' Create the child form
    Me.childA = New ChildAForm
    ' Add a handler to this class for when child A is updated
    AddHandler childA.ValueUpdated, AddressOf ChildAValueUpdated
    If Not Me.childB Is Nothing Then
    ' Make sure that the siblings are informed of each other.
        AddHandler childA.ValueUpdated, _
            AddressOf childB.ChildAValueUpdated
        AddHandler childB.ValueUpdated, _
            AddressOf childA.ChildBValueUpdated
    End If
    ' Show the form
    Me.childA.Show()
End Sub
```

All that remains is to implement the event handlers.

##### C#

```csharp
private void childA_ValueUpdated(object sender, ValueUpdatedEventArgs e)
{
    // Update the text box on this form (the parent) with the new
    /// value from the child
    this.uxChildAValue.Text = e.NewValue;
}
```

##### VB.NET

```vb
Private Sub ChildAValueUpdated(ByVal sender As Object, _
    ByVal e As ValueUpdatedEventArgs) Handles childA.ValueUpdated
    ' Update the value on this form (the parent) with the
    ' value from the child.
    Me.uxChildAValue.Text = e.NewValue
End Sub
```

And similarly in the child class.

##### C#

```csharp
public void childB_ValueUpdated(object sender, ValueUpdatedEventArgs e)
{
    // Update the text box on this form (child A) with the new value
    this.uxOtherValue.Text = e.NewValue;
}
```

##### VB.NET

```vb
Public Sub ChildBValueUpdated(ByVal sender As Object, _
    ByVal e As ValueUpdatedEventArgs)
    Me.uxOtherValue.Text = e.NewValue
End Sub
```

The code for this example is in [the accompanying github repository](https://github.com/colinangusmackay/blog-2005-04-22-passing-values-between-forms-in-net). The project is called SiblingToSiblingCS (for the C# version) and SiblingToSiblingVB (for the VB.NET version)

### Conclusion

It is quite simple to pass values from one object to another. In some instances it does take a little bit of effort to get it done right. Especially as it is all too easy to couple forms together that really shouldn't know about each other.

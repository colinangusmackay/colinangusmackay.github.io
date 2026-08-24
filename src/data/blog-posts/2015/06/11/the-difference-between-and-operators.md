---
title: "The difference between & and && operators"
slug: the-difference-between-and-operators
publishDate: 11 Jun 2015
description: "Here is a bit of code that was failing: if (product!=null & !string.IsNullOrEmpty(product.ProductNotes)) If you look closely you can see it uses just the..."
tags:
  - { name: "C#", slug: c }
  - { name: "conditional-AND operator", slug: conditional-and-operator }
---
Here is a bit of code that was failing:

```csharp
if (product!=null & !string.IsNullOrEmpty(product.ProductNotes))
```

If you look closely you can see it uses just the single ampersand operator, not the usual double ampersand operator.

There is a significant function difference between the two that under normal circumstances may not be obvious when performing logic operations on business rules. However in this case it become significant.

Both operators produce a Boolean result, both operators function as in this truth table

|                      |                       |        |
|----------------------|-----------------------|--------|
| LHS (Left-hand side) | RHS (Right-hand Side) | Result |
| False                | False                 | False  |
| True                 | False                 | False  |
| False                | True                  | False  |
| True                 | True                  | True   |

But there is a functional difference. For a result to be true, both LHS AND RHS must be true, therefore if LHS is false then the result of RHS is irrelevant as the answer will always be false.

The single ampersand operator (&) evaluates both sides of the operator before arriving at its answer.

The double ampersand operator (&& - also known as the conditional-AND operator) evaluates the RHS only if the LHS  is true. It short-circuits the evaluation so it doesn’t have to evaluate the RHS if it doesn’t have to. This means you can put the quick stuff on the left and the lengthy calculation on the right and you only ever need to do the lengthy calculation if you need it.

In the case above the code is checking if product is not null AND if product notes is not null or whitespace. It cannot evaluate the RHS if the LHS is false. Therefore a single ampersand operator will cause a failure when product is NULL simply because it is trying to evaluate both sides of the operator.

For more information see:

- **& operator** : <http://msdn.microsoft.com/en-us/library/sbf85k1c.aspx>
- **&& operator** : <http://msdn.microsoft.com/en-us/library/2a723cdk.aspx>

# birthday-greetings-kata
Improve domain modelling and learn about hexagonal architecture.

## Requirements
Write a program that sends a birthday greeting to any employees whose birthday it is today. Employees will be provided by a csv file.

## Goals
Come up with a solution that is:
- Testable; Application logic should be testable without needing to rely on sending actual emails.
- Flexible; External technologies should be able to be swapped out for others easily.

## Extra Credit
After building a solution, try to tackle this extra requirement:

>People born on the 29th of February should be sent greetings on the 28th unless it is a leap year.

- Is it clear what part of the system can be extended to provide this feature?
- Do existing systems need to be changed to fit this feature in?
- Does refactoring or implementing this feature cause existing tests to break?

## Final Solution

```ruby
require 'birthday_greetings'

email = Delivery::Smtp.new
people = People::FromCSV.new('path/to/people.csv')
greeting = Letters::Conditional.new(
  Letters::Template.new(%Q(
    Happy Birthday {first_name},

    Hopefully your day is swell!

    Regards,

    The birthday crew
  )),
  policy: Policies::LeapYearInclusiveEvent.new(Date.today.to_proc, key: :date_of_birth)
)

letter.send_to(people, via: email)
```
I want to be able to send messages to people.

When we add new features to the system we want to be able to replace or enhance existing components with new components rather than modify existing components.

## Letter

- fill with details (acts as a template)
- carrying a message
- send to a person

### Future Considerations

Letter that is only sent when certain criteria is met, i.e. on a user's birthday. Can this be achieved with a decorator?

---

## Person

- personalise a letter
- provide contact information to delivery method

We want to avoid the usual case of a `User` object where we end up with a massve list of defined attributes.

### Future Considerations

It would be nice to be able to have a composite wrapper for this class so to the rest of the system there is no different between a person and many people.

For example:

Letter - send -> person
Letter - send -> people

Letter doesn't know or care that it may be sending to one or many.

---

## Delivery Method

- deliver a message to a person

Person needs to communicate delivery specific details that change based on the delivery method

```ruby
# Person could dump all available contact info into the delivery method?
```
Person is just a hash at this point, What responsibility does a person have in this system?

Person could start as a hash but eventually we'd like to add variants where details are retrieved from a csv file. Details could also come from a database or api. 

### Future Considerations

- email -> requires the persons email
- console output -> requires nothing
- push notification -> requires device token

---

letter - send_to -> person

medium - deliver -> message - to -> person

person - provide contact information ->

It would be nice to end up with something like:

```
greeting = Letters::Personalised.new(Letters::Template.new('hello {name}!'))
recipients = People::Composite.new(
  People::FromHash.new(name: 'Lewis'), 
  People::FromCSV.new('other_people.csv')
)
delivery_method = Delivery::SmtpEmailClient.new('google.smtp.com', port: 487, from: 'system@gmail.com')
recipients.receive(greeting, via: delivery_method)
```

---

The `receive` method for `People::FromHash` is not right, if we were to derive siblings that were based on HTTP\DB\CSV then this method would be implemented the same way. Is the code suggesting:

1. Receive is not a valid responsibility, can we remove it whilst still preserving the nice behaviour of a composite person?
2. The attributes for a person should be abstracted one layer down. FromHashStrategy etc

Next step should be planning how a person can submit their contact information to the delivery method. Past self thought it could be a good idea to treat it like filling out a letter -> filling out a delivery form or something.

---

In the future when we look at implementing the birthday requirements, ideally I'd like to have something like:

```
  # Letters::BirthdayOnly - decorates -> Letter
  # A Birthday only letter will only send to a person if it is their birthday
```

How can this check be modelled without exposing an accessor to the birthday data?

Maybe a rule\policy object can be introduced and birthday only letter becomes Letters::Conditional. A conditional letter is given a policy that must be met in order to send the letter. BirthdayOnly would become a policy that gets checked before sending and if it fails then no letter is sent. Then we can freely compose these rules around sending letters conditionally.

When I was first fleshing out the design of the Person object, I felt like its responsibilities were weak but the behaviour of filling out details is starting to be useful outside of the personalised letters too. Filling out contact information for a delivery method and filling out a policy for evaluation are looming on the horizon!

---

New feature wanted: See the contents of delivery in standard output. Able to add this by defining a new delivery method which can then collaborate as if it were actually delivering messages to people! No existing code changes needed. 

Additionally say we wanted to log alongside sending messages then we still don't need to modify existing delivery methods. We could define a composite delivery method and then have it consist of an actual delivery method as well as the logging object.

---

Certain delivery methods require information before they can send, e.g. Smtp needs your email address, push notifications need a device token. The Filled decorator can be paired with such methods to achieve this. Before delivering it will tell the person to first fill out the underlying method as they would a letter. In my mind I likened this to filling out a envelope before sending it at the post office although it could have also been acheived with a different `deliver` signature like:

```ruby
def deliver(message, to:, details:)
end
```

This is probably also a bit easier to understand to be honest. The other problem here is that Smtp does not actually use the `to` argument. Instead it relies on the constructor to provide the `to_address` which feels misleading. I would feel misled if by doing `deliver('Hello', to: Person)`, I'm not actually sending the message to `Person`!

---

After considering the issues mentioned in the previous section, I decided to simplify how letters are filled out and sent by people. I reworked the `fill_out` method to yield a person's details to a block rather than push them into some object and return it. Here are some benefits:

- no more `person.receive`, instead we eliminate the extra dispatch and return to our original goal of `letter.send_to(person, via: email)`
- no more personalised decorator, template will fill itself out when sending. This also means we lost the ability to fill out a template by one person and send it to another but this behaviour is not that important to me just yet and I think it could be brought back easily.
- `fill_out` methods on composite objects is much more useful. Previously, all people would be filling out one template which would continously override the details. Now the composite objects forward the request to the children and each child calls the block. I think this will prove even more beneficial since our birthday only decorator will be able to skip filling out details for non birthday people.

Next go back and fill out the test coverage for current behaviour, it is lacking at the moment.

---

Refactored the composite people object to a generic delegator class, the logic stays the same but now it can be applied to anything. Check the sending specs for an example of sending letters to multiple people as well as sending multiple letters to one person, all enabled by the composite delegator. It works well with objects that adhere to [east-oriented coding](https://www.saturnflyer.com/blog/the-4-rules-of-east-oriented-code-rule-1).

Next was introducing a decorator only sends letters to people that match a certain condition. At the moment, the decorator asks the person to print itself and then forwards the details to the policy the check if the condition is met. I would like to rework this so that the policy <-> person interaction is a bit smoother with the decorator playing less of a mediator role.

```ruby
policy.evaluate?(person)
# rather than
person.fill_out { |person, details| policy.evaluate?(details) }
```

It will be nice to introduce boolean policy objects in the future to support:
- `AND`
- `OR`
- `NOT`

So we can compose complex rules:

```ruby
Policies::And.new(Policies::Matched.new(name: /a/i), Policies::BirthdayOn.new(today))
Policies::Not.new(Policies::BirthdayOn.new(today)) # Boohoo
```

Next steps:
- Birthday Value Object
- Conversion of date to value object in FromCSV
- Policy for birthday users

---

Main requirements are now completed except for an actual implementation of an email client but that would be trivial to do, see a skeleton version in `deliveries/smtp`.

Next is the bonus requirements of dealing with birthdays on February 29th. My initial questions (see the README) about implementing this:

>- Is it clear what part of the system can be extended to provide this feature?

  Yes, the policy module can be extended to provide a new condition for leap year birthdays.
>- Do existing systems need to be changed to fit this feature in?

  No, a new policy can be defined to be used with the conditional letter decorator.
>- Does refactoring or implementing this feature cause existing tests to break?

  No, feature can be implemented without touching any existing behaviour.

  We will see if this holds up when it is implemented but I feel confident that it will be easy to add.

  ---

  First difficulties with extra requirement is where this behaviour should live. Current thoughts:
  1. custom date class that works leap behaviour into eqls
  2. policy decorator that wraps the annual event\date reached policies
  3. new policy altogether

I think 2 is probably the way to go, 1. seems complicated trying to compare non leap year dates with leap year dates and I think 3 would duplicate much of what existing policies are already doing.

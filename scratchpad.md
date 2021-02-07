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

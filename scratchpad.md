I want to be able to send messages to people.

When we make add new features to the system we want to be able to replace or enhance existing components with new components rather than modify existing components.

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




        

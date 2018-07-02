# RSpec

## Links
[Best practices](http://www.betterspecs.org/)

## Install it

### For Rails
```bash
rails g rspec:install
```

## Matchers
* [Build-in matchers](https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers)

### [Composing Matchers](https://relishapp.com/rspec/rspec-expectations/v/3-7/docs/composing-matchers)

* change { }.by(matcher)
* change { }.from(matcher).to(matcher)
* contain_exactly(matcher, matcher, matcher)
* end_with(matcher, matcher)
* include(matcher, matcher)
* include(:key => matcher, :other => matcher)
* match(arbitrary_nested_structure_with_matchers)
* output(matcher).to_stdout
* output(matcher).to_stderr
* raise_error(ErrorClass, matcher)
* start_with(matcher, matcher)
* throw_symbol(:sym, matcher)
* yield_with_args(matcher, matcher)
* yield_successive_args(matcher, matcher)


## Хелперы

### let
Создает функцию-геттер, возвращающую значение блока.
Значение кешируется между вызовами внутри одного примера, но не кешируется между примерами.
Выполняется lazy (можно заставить выполняться перед каждым примером, записав как let!. В этом случае он выполняется так же, как хук before)
```ruby
let(:count) { $count + 1 }
```
### собственные хелперы
добавить собственные хелперы во все группы c метаданными :foo => :bar
```ruby
require './helpers'

RSpec.configure do |c|
  c.include Helpers, :foo => :bar、
  #c.extend Helpers
end

RSpec.describe "an example group", :foo => :bar do
  it "has access to the helper methods defined in the module" do
    expect(help).to be(:available)
  end
end

```

## And и Or
https://relishapp.com/rspec/rspec-expectations/v/3-7/docs/compound-expectations
```ruby
it "passes when both are true" do
  expect(string).to start_with("foo").and end_with("bazz")
end
it "passes when using boolean AND & alias" do
    expect(string).to start_with("foo") & end_with("bazz")
end

it "is green, yellow or red" do
    expect(light.color).to eq("green").or eq("yellow").or eq("red")
end
it "passes when using boolean OR | alias" do
  expect(light.color).to eq("green") | eq("yellow") | eq("red")
end
```

## Mocks
http://www.rubydoc.info/gems/rspec-mocks/frames

обычно размещают в before-хуке (before(:example)).

* allow_any_instance_of(Aws::CognitoIdentityProvider::Client).to receive(:admin_initiate_auth).and_return(authorize_response)
* allow_any_instance_of(Aws::CognitoIdentityProvider::Client).to receive(:admin_initiate_auth).and_raise(<error class>, 'message')
* allow_any_instance_of(MCS::Client).to receive_message_chain(:status, :body).and_return(status)
* allow(controller).to receive(:admin_current_user).and_return(user)
* allow(dbl).to receive(:foo).with(5).and_return(:return_value)
* expect(obj).to receive(:hello).with("world").exactly(3).times

```ruby
allow_any_instance_of(Aws::CognitoIdentityProvider::Client).to(receive(:confirm_forgot_password)).tap do |receive|
  receive.and_raise(cognito_error_class.new(Seahorse::Client::RequestContext.new, 'error')) if cognito_error_class
end
```

### double
создает дубль существующего объекта `#instance_double(doubled_class, name, stubs) ⇒ Object` или объект-заглушку `double(name, stubs)` или заглушку с валидацией по классу , на который можно навесить какое-либо поведение мок-методами.

Варианты создания
```ruby
book = double("book", :title => "The RSpec Book")
allow(book).to receive(:title) { "The RSpec Book" }
allow(book).to receive(:title).and_return("The RSpec Book")
allow(book).to receive_messages(
    :title => "The RSpec Book",
    :subtitle => "Behaviour-Driven Development with RSpec, Cucumber, and Friends")
```

Проверка вызова метода
```ruby
validator = class_double(Validator, "Validator double")
expect(validator).to recieve(:validate).with("12343242")
expect(validator).to recieve(:validate).with(anything())
expect(validator).to recieve(:validate).with(1, 'smstr', any_args)
expect(validator).to recieve(:validate).with(hash_including(:a => '1'))
expect(validator).to recieve(:validate).with(array_including('1'))
...
```
См. другие матчеры аргументов [Arguments matchers](http://www.rubydoc.info/gems/rspec-mocks/RSpec/Mocks/ArgumentMatchers#boolean-instance_method)

```ruby
expect(double).to receive(:msg).exactly(n).times
expect(double).to receive(:msg).at_least(:once)
expect(double).to receive(:msg).at_least(:twice)
expect(double).to receive(:msg).at_least(n).times
expect(double).to receive(:msg).at_most(:once)

expect(double).to receive(:msg).ordered #порядок для данного double будет важен
```

#### Возвращаемое значение
Годится и для expect, и для allow
```ruby
expect(double).to receive(:msg) { value }
allow(double).to receive(:msg).and_return(value1, value2, value3)
allow(double).to receive(:msg).and_raise(error)
allow(double).to receive(:msg).and_throw(:msg)
allow(double).to receive(:msg).and_yield(values, to, yield)
expect(obj).to receive(:hello).with("world").exactly(3).times
# произвольное тело метода
expect(double).to receive(:msg) do |arg|
  expect(arg.size).to eq 7
end
# если метод принимает блок
expect(double).to receive(:msg) do |&arg|
  begin
    arg.call
  ensure
    # cleanup
  end
end
# делегирование оригинальному методу
expect(Person).to receive(:find).and_call_original
```

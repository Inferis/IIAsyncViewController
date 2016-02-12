# IIAsyncViewController

A UIViewController subclass specifically geared toward async data fetching.

## Description

`IIAsyncViewController` is a subclass of viewcontrollers that's engineered to provide  handle asynchronous data. It wraps its view in a state view which will:

* display a loading spinner while data is being requested,
* the original view itself when data was correctly loaded,
* a "no data" message when the request succeeded but no data was retrieved,
* and finally an error message when an error occurred

It is created so to be flexible: you can use the default components, but the controller allows you to provide your own views for maximum flexibility at a cost of a little bit more work.

## Documentation

Forthcoming. I've written this on the plane from SF to Europe, and now I'm tired.

Classes and protocols are documented enough to get you started, I think.

## Tests

They aren't there. Will be, but not now. Too tired, my friend.

## CocoaPods

IIAsyncViewController is available as a CocoaPod. Add the following line to your Podfile:

```
pod 'IIAsyncViewController'
```

And you're done.

## License

**IIAsyncViewController** is published under the MIT License.

See [LICENSE](LICENSE) for the full license.

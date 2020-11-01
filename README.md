## Functional Requirements
* Display a list of products showing at least the title, price and an image for each one
* Customers should be able to search for products by their name
* Selecting a product from the product’s list should display a details page,
where customers can find out more information about the product
* Products should be persisted​, meaning that if the app is relaunched when the
device has no internet connection, the last downloaded list of products are displayed

## Non Functional Requirements
* The app should be built with good UX and use iOS native UI elements where possible, with a design of your choosing
* Critical aspects of the app should be covered by Unit Tests
* A core user journey should be covered with a UI Automation Test
* Document in the README anything that is worth noting
* If used, justify the use of any third party libraries in the README

# Dependencies used

**AlamofireImage** - I used this because its a solid image fetching implementation that handles caching and is well supported by the community for new iOS versions. I believe where possible we shouldn't reinvent the wheel and we should contribute commonly used features like image fetching to the open source community.

**Reachability** - This handles reachability well and I used it for similar reasons as above.

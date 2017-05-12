# Setup

The following environment variables must be added to an intializer to be loaded before the instagram.rb initializer.

- ENV['INSTAGRAM_CLIENT_ID']

- ENV['INSTAGRAM_CLIENT_SECRET']

- ENV['INSTAGRAM_REDIRECT_URI']



# Design

**Back-end**

- [https://github.com/facebookarchive/instagram-ruby-gem](https://github.com/facebookarchive/instagram-ruby-gem) is used to handle API calls

- Once a user has authenticated, their access token is stored in the session, along with basic user data such as name and profile pic. This allows the header to always display the username and profile pic when a user is logged in.

- When a user logs out, or when there is an authentication error with Instagram, all user info in the session is destroyed. The user will be redirected to the home page, where a flash is displayed if appropriate.

- The primary API endpoint used is /users/self/media/recent

- Due to Sandbox API limitations, only the user&#39;s 20 most recent posts can be accessed.

- The Media Controller retrieves the media feed, then hands it off to the ApiParser for parsing.

- The ApiParser will return an array of Image objects, which will then be used by the view to populate the gallery.

- Carousel media will have any images within converted to standard Images and put alongside the rest.

- One thing to note is that Active Record is not used in the app - there is no database interaction at all. All data is retrieved from the Instagram API when needed, with a few short strings like access token and username persisted in the session.

- Client ID and Client Secret are stored in environment variables.

- All models and controllers have thorough unit test coverage.



**Front-end**

- Bootstrap 4 does the heavy lifting on the front end. Responsive design was a major focus throughout.

- [Photoswipe](http://photoswipe.com/) is used to implement the lightbox display in the gallery. It supports pre-loading next/previous pictures, low-res placeholders, and has excellent touch support on mobile.

# Challenges

- Last year Instagram added severe limitations to their API. All apps must start in sandbox mode and request approval from Instagram to go live. Apps such as this one, which primarily display a user&#39;s media, are explicitly disallowed. As such it is very unlikely that Simplepics would ever be able to leave Sandbox mode.

- Limitations on Sandbox mode mean that it is very awkward to bring new users to the site, as they must receive an invitation on Instagram and sign up as a sandbox developer to be able to authenticate with the site. Additionally, only 10 users are allowed to access the site in this way, and only the 20 most recent media from each user can be accessed.

- Although Photoswipe is an excellent library in terms of UX and feature set, it is not very developer friendly and is quite awkward to work with. There is a [rails gem](https://github.com/skakri/photoswipe-rails) to add it to the asset pipeline, but the gem appears to be buggy and does not add all required resources, several of which had to instead be included manually in the repo.



# Roadmap

If I were to continue working on this project, these are a few of the things which would be at the top of my to-do list.

- Add feature specs to more thoroughly test API functionality and views.

- Fix the Photoswipe rails gem so that all necessary resources are included.

- Add the ability to download an individual image from the lightbox or bulk download from the gallery view.

- Consider removing unused dependencies such as Active Record.

- If we can get out of Sandbox mode, some changes will need to be made to handle an unlimited number  of images. The media API endpoint is paginated, and although it is easy to make repeated calls to get all the images in the feed, this would be a bad idea because users with a lot of posts would consume too many server resources. Every image that gets parsed on the backend generates 4 objects - one Image and three Sources. The solution to this would probably be either pagination or infinite scroll on the front end, with Ajax calls to the server to retrieve more API images when necessary. This would mean that the server never needs to store more than 20 or so Images in memory.

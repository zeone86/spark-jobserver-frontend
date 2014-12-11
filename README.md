Spark JobServer Frontend
========================

This is a single page application that can be used to monitor and drive the [Spark JobServer](https://github.com/spark-jobserver/spark-jobserver).

Usage
------

The application can be used both inside the JobServer itself, or standalone. In the first case, build the application and deploy it inside `spark-jobserver/main/resources/html`. If you want to use it from the outside, you will have to patch the JobServer routes to add [CORS](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing) support.

Build and development
----------------------

To build the application, you will need [node.js](http://nodejs.org/), [npm](https://www.npmjs.org/), [gulp](http://gulpjs.com/) and [browserify](http://browserify.org/). First, install the dependencies with

    npm install

Then, you can have a development version with live reload with

    gulp watch

When you are done, create a production ready version of the JS bundle inside the `dist` folder:

    gulp build

If you want to serve the application directly from the JobServer, you will need to run the following task, that uses different paths:

    gulp build-jobserver

License
-------

[Apache 2](http://opensource.org/licenses/Apache-2.0)
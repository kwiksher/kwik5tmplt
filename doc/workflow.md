

1. put images in App/demo/assets/page01

	- logo
	- panel
	- message
	- button
	- background
	- shape1
	- shape2

	Tool
	- Finder/File Expolorer
	- Plugin for Photoshop or XD will export images
	- Editor
		- html post image form
    - network
      - display.loadRemoteImage

        https://solar2d.com/images/logo.png

        > access images of XD shared view? or able to load them all?

      - network.download

1. Create layer structure

	- Editor lists the images
		- Order Top/Bottom/Up/Down

    frontEnd uses **Adobe React Spectrum** (in future, support screen reader etc)

	  REST API to get the list of images and post the orderd list back

    GET /layers

    ```yaml
      - background: []
      - button: []
      - logo: []
      - message: []
      - panel:
    ```

    Change the order of layers

    ```yaml
    POST /layers

      - logo: []
      - panel:
          - message: []
          - button: []
      - background: []
    ```

2. Set animation and button

    > test KwikTheCat for evaluation

    one by one

    ```yaml
    POST /layers/logo

    classes:
    - animation
    ```

    Or

      ```yaml
      POST /layers/logo
      Content-Type: application/yaml

      - transition: bounce
      - params:
          height: 400
          width: 200
          time: 1000
          iterations: 0
      ```

    **GUI** in Edtior(Solar2D) for transformation, draggable to set a position

    ```yaml
    POST /layers/panel/button

    classes:
    - button
    ```


    All together

    ```yaml
    POST /layers

    - logo: []
      classes:
      - animation
    - panel:
      - message: []
      - button: []
        classes:
        - button
    - background: []
    ```


module Material.Button
  ( Model, Action, update
  , flat, raised, fab, minifab, icon
  , colored, primary, accent
  , ripple, disabled
  , View, Container, Observer, Instance, instance
  , render
  ) where

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#buttons-section):

> The Material Design Lite (MDL) button component is an enhanced version of the
> standard HTML `<button>` element. A button consists of text and/or an image that
> clearly communicates what action will occur when the user clicks or touches it.
> The MDL button component provides various types of buttons, and allows you to
> add both display and click effects.
>
> Buttons are a ubiquitous feature of most user interfaces, regardless of a
> site's content or function. Their design and use is therefore an important
> factor in the overall user experience. See the button component's Material
> Design specifications page for details.
>
> The available button display types are flat (default), raised, fab, mini-fab,
> and icon; any of these types may be plain (light gray) or colored, and may be
> initially or programmatically disabled. The fab, mini-fab, and icon button
> types typically use a small image as their caption rather than text.

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/buttons.html).

Refer to 
[this site](https://debois.github.io/elm-mdl/#/buttons) 
for a live demo. 

 
# Elm architecture
@docs Model, Action, update, View

# Options
@docs colored, primary, accent, ripple, disabled

# View
Refer to the
[Material Design Specification](https://www.google.com/design/spec/components/buttons.html)
for details about what type of buttons are appropriate for which situations.

@docs flat, raised, fab, minifab, icon

# Component support
@docs instance, render

## Component instance types

@docs Container, Observer, Instance

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events 
import Effects exposing (Effects, none)
import Signal exposing (Address, forwardTo)

import Parts exposing (Indexed, Index)

import Material.Helpers as Helpers
import Material.Options as Options exposing (cs, Property)
import Material.Ripple as Ripple


{-| MDL button.
-}


-- MODEL


{-| 
-}
type alias Model = Ripple.Model


-- ACTION, UPDATE


{-| 
-}
type alias Action
  = Ripple.Action


{-| Component update.
-}
update : Action -> Model -> (Model, Effects Action)
update =
  Ripple.update 


-- VIEW


{-| 
-}
type alias Config = 
  { ripple : Bool 
  , onClick : Maybe Attribute
  , disabled : Bool
  }


defaultConfig : Config
defaultConfig = 
  { ripple = False
  , onClick = Nothing
  , disabled = False
  }
 

type alias Property = 
  Options.Property Config 


onClick : Address a -> a -> Property
onClick addr x =
  Options.set
    (\options -> { options | onClick = Just (Html.Events.onClick addr x) })


{-|
   TODO
-}
ripple : Property 
ripple = 
  Options.set
    (\options -> { options | ripple = True })


{-| TODO
-}
disabled : Property
disabled = 
  Options.set
    (\options -> { options | disabled = True })


{-| Color button with primary or accent color depending on button type.
-}
colored : Property
colored =
  cs "mdl-button--colored"


{-| Color button with primary color.
-}
primary : Property
primary =
  cs "mdl-button--primary"


{-| Color button with accent color. 
-}
accent : Property
accent = 
  cs "mdl-button--accent"


view : Address Action -> Model -> List Property -> List Html -> Html
view addr model config html =
  let 
    summary = Options.collect defaultConfig config
  in
    Options.apply summary button 
      [ cs "mdl-button"
      , cs "mdl-js-button" 
      ]
      [ Just (Helpers.blurOn "mouseup")
      , Just (Helpers.blurOn "mouseleave")
      , summary.config.onClick 
      , if summary.config.disabled then Just (Html.Attributes.disabled True) else Nothing
      ]
      (if summary.config.ripple then
          Ripple.view 
            addr
            [ class "mdl-button__ripple-container"
            , Helpers.blurOn "mouseup" 
            ]
            model
          :: html
        else 
          html)


{-| Type of button views. 
-}
type alias View = 
  Address Action -> Model -> List Property -> List Html -> Html


{-| From the
[Material Design Specification](https://www.google.com/design/spec/components/buttons.html#buttons-flat-buttons):

> Flat buttons are printed on material. They do not lift, but fill with color on
> press.
>
> Use flat buttons in the following locations:
>
>  - On toolbars
>  - In dialogs, to unify the button action with the dialog content
>  - Inline, with padding, so the user can easily find them

Example use (uncolored flat button, assuming properly setup model):

    import Material.Button as Button

    flatButton : Html
    flatButton = Button.flat addr model Button.Plain [text "Click me!"]

-}
flat : Property
flat = Options.nop


{-| From the
[Material Design Specification](https://www.google.com/design/spec/components/buttons.html#buttons-raised-buttons):

> Raised buttons add dimension to mostly flat layouts. They emphasize functions
> on busy or wide spaces.
>
> Raised buttons behave like a piece of material resting on another sheet –
> they lift and fill with color on press.

Example use (colored raised button, assuming properly setup model):

    import Material.Button as Button

    raisedButton : Html
    raisedButton = Button.raised addr model Button.Colored [text "Click me!"]

-}
raised : Property 
raised = cs "mdl-button--raised"


{-| Floating Action Button. From the
[Material Design Specification](https://www.google.com/design/spec/components/buttons-floating-action-button.html):

> Floating action buttons are used for a promoted action. They are distinguished
> by a circled icon floating above the UI and have motion behaviors that include
> morphing, launching, and a transferring anchor point.
>
> Floating action buttons come in two sizes:
>
>  - Default size: For most use cases
>  - Mini size: Only used to create visual continuity with other screen elements

This constructor produces the default size, use `minifab` to get the mini-size.

Example use (colored with a '+' icon):

    import Material.Button as Button
    import Material.Icon as Icon

    fabButton : Html
    fabButton = fab addr model Colored [Icon.i "add"]
-}
fab : Property
fab = cs "mdl-button--fab"


{-| Mini-sized variant of a Floating Action Button; refer to `fab`.
-}
minifab : Property 
minifab = cs "mdl-button--mini-fab"


{-| The [Material Design Lite implementation](https://www.getmdl.io/components/index.html#buttons-section)
also offers an "icon button", which we
re-implement here. See also
[Material Design Specification](http://www.google.com/design/spec/components/buttons.html#buttons-toggle-buttons).
Example use (no color, displaying a '+' icon):

    import Material.Button as Button
    import Material.Icon as Icon

    iconButton : Html
    iconButton = icon addr model Plain [Icon.i "add"]
-}
icon : Property 
icon = cs "mdl-button--icon"



-- COMPONENT


{-|
-}
type alias Container c =
  { c | button : Indexed Model }


{-|
-}
type alias Observer obs = 
  Parts.Observer Action obs


{-|
-}
type alias Instance container obs =
  Parts.Instance Model container Action obs (List Property -> List Html -> Html)


{-| Create a component instance. Example usage, assuming you have a type
`Action` with a constructor `MyButtonAction : Action`, and that your 
`model` has a field `mdl : Material.Model`. 

    type alias Mdl = 
      Material.Model 


    myButton : Button.Instance Mdl Action 
    myButton = 
      Button.instance 0 MDL
        Button.raised (Button.model True)
        [ Button.fwdClick MyButtonAction ]


    -- in your view:
    ... 
      div 
        []
        [ myButton.view addr model.mdl [ Button.colored ] [ text "Click me!" ]
-}
instance 
  : View
  -> Model
  -> (Parts.Action (Container c) obs -> obs)
  -> Parts.Index
  -> Instance (Container c) obs

instance view model0 lift = 
  Parts.create 
    view update .button (\x y -> {y | button = x}) model0 lift 



{-|
  TODO
-}
render 
  : (Parts.Action (Container c) obs -> obs)
  -> Parts.Index
  -> Address obs
  -> (Container c)
  -> List Property 
  -> List Html 
  -> Html
render lift index = 
  ((Parts.create
      view update .button (\x y -> {y | button=x}) Ripple.model lift)
    index).view []
    
  

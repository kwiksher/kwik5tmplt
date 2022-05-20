---
title: "Design"
chapter: true
weight: 10
---

# Design

Project model

- robotlegs
- template
  - components
  - commands

Tools 

- image exporter

  PS/XD UXP

- visual editor (frontEnd)

  React
  - uxp plugin for Ps or XD
  - web app

  Solar2D
  - live editor

- REST server 

  - pegasus-harness
  - pegasus-launcher

    frontEnd app sends REST API requests to harness of pegasus lua server

    this server offers the renderer of .lua for components and commands

- other tools
  - generate_scene_index

Sample projects

---
Image Exporter plugin for Adobe Photoshop


<img src="./img/2022-05-18-13-25-58.png" width="360">

---
Project Model

> /kwik5/sandbox/Ps/react-uxp-styles/Project/Solar2D

<img src="./img/2022-05-18-13-20-45.png" width="360">

---
Visual Editor(React)


{{webview html panel}}

- UXP
- Browser

---
Visual Live Editor(Solar2D)

<img src="./img/2022-05-18-13-15-45.png" width="800">

---
Tools

- develop/Solar2D/tools/pegasus-harness
- develop/Solar2D/tools/pegasus-launcher

  REST API requests from httpYac are sent to pegasus

<img src="./img/2022-05-18-13-37-14.png" width="600">

generate_scene_index

<img src="./img/2022-05-18-13-39-54.png" width="600">

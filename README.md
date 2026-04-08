# Minecraft Map

A real-time web application that renders the entire world as a Minecraft-style map. Every tile is generated on-the-fly from real geographic data -- roads, buildings, forests, water, elevation -- all drawn with authentic Minecraft block textures and north-shading.

Built with TypeScript, Express, Leaflet, and Node Canvas. Features user accounts, real-time friend tracking over WebSocket, turn-by-turn navigation with a Minecraft compass, and a full inventory-style UI.

## Features

**Map**
- Live tile generation from OpenStreetMap, Overture Maps, and AWS Terrain Tiles
- 3D voxel pipeline: fetch, classify, heightmap, voxelize, render
- Biome-aware block palettes (Mediterranean, temperate, arid, arctic)
- 24 semantic terrain classes (water, forest, buildings, roads, etc.)
- Toggle between Minecraft, Satellite, and Roads layers

**Navigation**
- Search any place by name with live autocomplete
- Turn-by-turn directions via OSRM
- Animated Minecraft compass that points toward your next step
- GPS location tracking with a Minecraft player marker

**Social**
- User accounts with registration and login
- Friend codes -- add friends by sharing a 6-character code
- Real-time friend locations on the map over WebSocket
- In-app chat

**UI**
- Minecraft inventory-style panels and buttons
- Day/night clock with real-time weather
- Ambient sounds (birds, wind) based on visible terrain
- Achievement popups, Nether portal transitions
- Responsive mobile layout with map-frame safe zones

## Quick Start

```bash
cd app
npm install
npx tsx src/serve.ts
```

Open **http://localhost:3001**.

## Docker

```bash
docker build -t minecraft-map .
docker run -p 3001:3001 minecraft-map
```

## How It Works

Each 256x256 tile passes through a five-stage pipeline:

1. **Fetch** -- vector tiles, building footprints, roads, and elevation for the tile bounds
2. **Classify** -- rasterize features into a semantic grid (water, road, building, forest, park...)
3. **Heightmap** -- decode Terrarium elevation into Minecraft Y levels
4. **Voxelize** -- place blocks column-by-column with surface materials, trees, building extrusion, water
5. **Render** -- top-down orthographic projection with Minecraft north-shading

Cold tiles take 3-6 seconds. Cached tiles are instant.

## Data Sources

| Source | Provides |
|--------|----------|
| [VersaTiles](https://versatiles.org) | Base vector tiles (roads, land use, water) |
| [Overpass API](https://overpass-api.de) | OSM buildings, roads, paths, land features |
| [Overture Maps](https://overturemaps.org) | AI building footprints (fills OSM gaps) |
| [AWS Terrain Tiles](https://registry.opendata.aws/terrain-tiles/) | Elevation data |
| [OSRM](http://router.project-osrm.org) | Routing for turn-by-turn navigation |
| [Photon](https://photon.komoot.io) | Geocoding for place search |

## Tech Stack

- **Runtime**: Node.js + TypeScript (tsx)
- **Server**: Express.js with WebSocket (ws)
- **Database**: SQLite via better-sqlite3
- **Auth**: bcryptjs + session cookies
- **Frontend**: Leaflet.js, vanilla JS, Minecraft font
- **Rendering**: Node Canvas (2D voxel projection)
- **Vector tiles**: @mapbox/vector-tile + pbf + PMTiles

## Project Structure

```
app/
  src/
    serve.ts          Server, API routes, WebSocket, auth
    index.ts          Tile generation pipeline entry
    types.ts          Shared type definitions
    ingest/           Data fetching (vector tiles, elevation, buildings)
    semantic/         Feature classification and rasterization
    terrain/          Heightmap processing
    palette/          Block type definitions and biome palettes
    voxel/            Voxel world construction and block placement
    preview/          Top-down rendering with north-shading
    util/             Caching, math, helpers
  public/
    index.html        Single-file frontend (HTML + CSS + JS)
    icons/            Minecraft sprites and compass frames
    sounds/           Ambient audio files
    clock/            Day/night cycle clock frames
    menu/             Title screen assets
  test/               Auth, friends, WebSocket, waypoint tests
```

## License

MIT

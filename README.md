# Tether

**Scheduled autonomous rides for people who can't safely use a regular robotaxi.**

Older adults, dialysis and physio patients, and people with mobility limits in car-dependent
suburbs make predictable trips (appointments, pharmacy, groceries). Tether plans those rides
ahead, adds a **Trust Circle** (a trusted contact confirms the handoff at the door), models
**Ontario winters**, and turns the fleet into a **community sensor** for road hazards.

Built for a hackathon in MATLAB. Base MATLAB only, no toolboxes required (R2019b+ recommended).

## Quick start

1. Clone or download this repo.
2. In MATLAB, set the Current Folder to the repo folder.
3. Run:

   ```matlab
   runTether
   ```

It takes about a minute and produces 8 figures plus a summary in the Command Window.

## What it shows

| Output | Purpose |
|---|---|
| Winter physics | Braking distance and safe speed on dry, wet, and ice |
| City map | Street network coloured by winter risk |
| Demand | Appointment peaks across a weekday |
| **Hero graph** | On-time % vs fleet size, dry vs winter (the winter penalty, in vehicles) |
| Delay vs cost | Fleet-size tradeoff |
| Handoff cost | How slow Trust Circle handoffs eat fleet capacity |
| Fleet as sensor | Weekly hazard detection heatmap |
| vs paratransit | Booking lead time, cost per ride, on-time rate |

## Files

| File | Role |
|---|---|
| `runTether.m` | Main script (run this) |
| `TetherParams.m` | All assumptions, edit here |
| `buildCity.m`, `buildTravelTimes.m`, `safeSpeed.m` | Street graph and weather-aware travel times |
| `generateDemand.m` | Daily appointment demand |
| `runTetherSim.m` | Scheduling with greedy insertion |
| `sweepFleet.m`, `handoffSweep.m` | Fleet-size and handoff sweeps |
| `sensorWeek.m`, `trustCircleDemo.m`, `plotWinterModel.m` | Sensor layer, handoff state machine, physics plots |
| `docs/Tether_Team_Plan.xlsx` | Team roles and task tracker |

## Limits (stated honestly)

- Synthetic city, not a real map.
- Costs and the paratransit baseline in `TetherParams.m` are **assumptions** until replaced with cited data.
- No ride pooling yet, so cost per ride is a conservative upper bound.
- A vehicle cannot physically help someone out; the Trust Circle handoff and a clinic partner cover that.
- Simulation results are estimates, not proof.

## Team workflow

- One person owns each file (see the Roles tab in `docs/Tether_Team_Plan.xlsx`).
- Work on a branch, open a pull request, merge to `main`:

  ```
  git checkout -b feature/pooling
  git add . && git commit -m "Add ride pooling"
  git push -u origin feature/pooling
  ```
- Pull before you start: `git pull`.

## License

MIT, see `LICENSE`.

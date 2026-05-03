# Slot Machine Logic

## Defaults
- Starting coins: `1000`
- Bet: `10`
- Reels: `3`

## Spin Flow
- Ignore spin requests while reels are already spinning.
- Require coins greater than or equal to bet.
- Subtract bet before spinning.
- Randomize one result per reel.
- Stop reels with staggered delays for mobile-friendly feedback.
- Award payout after all reels stop.

## Payouts
- `777 + 777 + 777`: jackpot, `bet * 50`
- Any 3 matching symbols: big win, `bet * 10`
- Any 2 matching symbols: small win, `bet * 2`
- No match: `0`

## UX Feedback
- Spin sound on spin start.
- Win sound for small/big wins.
- Jackpot sound for jackpot.
- Display win amount after evaluation.


import "../styles/globals.css";
import { AppWrapper } from "../state";
import type { AppProps } from "next/app";

import { getDefaultWallets, RainbowKitProvider } from "@rainbow-me/rainbowkit";
import { chain, configureChains, createClient, WagmiConfig } from "wagmi";
import { alchemyProvider } from "wagmi/providers/alchemy";
import { publicProvider } from "wagmi/providers/public";

import { customTheme, BlockieAvatar } from "../components/ConnectButton";

const { chains, provider } = configureChains(
  [chain.rinkeby, chain.mainnet],
  [publicProvider(), alchemyProvider({ apiKey: process.env.ALCHEMY_KEY })]
);

const { connectors } = getDefaultWallets({
  appName: "Zodiac NFT",
  chains,
});

const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
});

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <AppWrapper>
      <WagmiConfig client={wagmiClient}>
        <RainbowKitProvider
          chains={chains}
          theme={customTheme}
          avatar={BlockieAvatar}
          initialChain={4}
        >
          <Component {...pageProps} />
        </RainbowKitProvider>
      </WagmiConfig>
    </AppWrapper>
  );
}

export default MyApp;

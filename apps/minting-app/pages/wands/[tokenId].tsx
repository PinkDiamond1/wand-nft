import type { NextPage } from "next";
import { useRouter } from "next/router";
import React, { useEffect, useState } from "react";
import "@rainbow-me/rainbowkit/styles.css";
import { useContractRead } from "wagmi";
import WandView from "../../components/WandView";
import Layout from "../../components/Layout";
import styles from "../../styles/Home.module.css";

import wandContract from "../../utils/contract";

const WandsPage: NextPage = () => {
  const router = useRouter();
  const { tokenId } = router.query;

  const { data, isError, isLoading } = useContractRead({
    addressOrName: wandContract.address,
    contractInterface: wandContract.abi,
    functionName: "tokenURI",
    args: tokenId,
    enabled: !!tokenId,
    onError(error) {
      console.log("Error", error);
    },
  });

  // temp workaround for SRR hydration issue
  const [mounted, setMounted] = useState(false);
  useEffect(() => {
    setMounted(true);
  }, []);
  useEffect(() => {
    console.log("data", data);
  }, [data]);
  return (
    <Layout description="Zodiac Wands Minting App">
      <div className={styles.centerContainer}>
        {data && <WandView tokenUri={data} />}
      </div>
    </Layout>
  );
};

export default WandsPage;

const getImageUri = (tokenUri: string) => {
  const json = atob(tokenUri.slice("data:application/json;base64,".length));
  if (!json) return "";
  const obj = JSON.parse(json);
  return obj.image;
};

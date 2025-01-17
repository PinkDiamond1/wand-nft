import Link from "next/link";
import { useRouter } from "next/router";
import ButtonBackground from "./ButtonBackground";
import ConnectButton from "../ConnectButton";
import MintButton from "../MintButton";
import styles from "./Nav.module.css";
import classNames from "classnames";

const Nav: React.FC = () => {
  const router = useRouter();
  const currentRoute = router.pathname;
  return (
    <nav className={styles.nav}>
      <ul>
        <li
          className={classNames(styles.createLink, {
            [styles.active]: currentRoute === "/",
          })}
        >
          <Link href="/">Create</Link>
          <ButtonBackground className={styles.aboutBackground} />
        </li>
        <li
          className={classNames(styles.wandsLink, {
            [styles.active]: currentRoute === "/wands",
          })}
        >
          <Link href="/wands">Wands</Link>
          <ButtonBackground className={styles.wandsBackground} />
        </li>
      </ul>
      {currentRoute === "/" && <MintButton />}
      <div className={styles.AccountConnect}>
        <ConnectButton />
      </div>
    </nav>
  );
};

export default Nav;

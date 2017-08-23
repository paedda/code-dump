<?php

class PetersHelper {

	/**
	 * @var int
	 */
	CONST MAX_RETRIES = 3;

	/**
	 * @var object
	 */
	private static $_instance;

	/**
	 * @var string
	 */
	protected $logFile = '/tmp/id-debug.log';

	/**
	 * @return PetersHelper
	 */
	public static function getInstance() {
		if (self::$_instance === null)
			self::$_instance = new self();
		return self::$_instance;
	}

	/**
	 *  usage:
	 *          $result = Helper::_retry(
	 *				function () use ($url, $dest) {
	 *					if ($result = copy($url, $dest))
	 *                      return $result;
	 *					else
	 *						throw new Exception(true);
	 *   			}
	 *			);
	 *
	 * @param     $function
	 * @param int $retries
	 *
	 * @return bool
	 */
	public function _retry($function, $retries = 1) {
		try {
			return $function();
		} catch (Exception $e) {
			if ($retries <= self::MAX_RETRIES) {
				sleep($retries);
				return $this->_retry($function, $retries + 1);
			} else {
				return false;
			}
		}
	}

	/**
	 * @param mixed $data
	 * @param bool  $printLog
	 *
	 * @return bool
	 */
	public function debugLog($data, $printLog = false) {

		if (is_string($data))
			$data = "[{$data}]";
		else
			$data = json_encode($data);

		$output = "[" . date('r') . "] - [DEBUGGER] -> Data: {$data}\n";

		// print out log if flag is passed in
		if ($printLog) {
			echo "<pre>"; print_r($data); echo "</pre>";
		}

		// append log to file
		file_put_contents($this->logFile, $output, FILE_APPEND);

		return true;
	}

	/**
	 * parses out domain plus TLD only
	 *
	 * @param $url
	 *
	 * @return string
	 */
	public function getDomain($url) {
		$urlParts = parse_url($url);
		$domainParts = explode('.', $urlParts['host']);

		// check for second level domains
		if (preg_match('/(au)|(uk)|(za)|(in)|(il)|(id)|(cr)|(jp)|(kr)|(ck)|(in)/', end($domainParts), $match)) {
			$tldParts = array_slice($domainParts, -3);
		} else {
			$tldParts = array_slice($domainParts, -2);
		}

		$topDomain = implode('.', $tldParts);

		return $topDomain;
	}
}

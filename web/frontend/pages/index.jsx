export default function HomePage() {
  return (
    <form enctype="multipart/form-data" method="post" action="/api/files">
      <input type="file" name="file" />
      <input type="submit" value="Upload" />
    </form>
  );
}
